// Rendert de .dc.html-ontwerpen naar PNG met een minimale nabootsing van de DC-runtime.
// Gebruik: node render.js <projectmap> <uitvoermap> <naam1.dc.html> [...]
const fs = require('fs');
const path = require('path');
const { chromium } = require('playwright');

const [, , projectDir, outDir, ...files] = process.argv;

const runtime = `
class DCLogic {
  constructor(props) { this.props = props || {}; this.state = {}; }
  setState(s) { Object.assign(this.state, typeof s === 'function' ? s(this.state) : s); }
  forceUpdate() {}
}
function lookup(scope, expr) {
  expr = expr.trim();
  if (expr === 'true') return true;
  if (expr === 'false') return false;
  if (/^-?\\d+(\\.\\d+)?$/.test(expr)) return Number(expr);
  let cur = scope;
  for (const part of expr.split('.')) {
    if (cur == null) return undefined;
    cur = cur[part];
  }
  return cur;
}
function interp(scope, str) {
  return str.replace(/\\{\\{([^}]+)\\}\\}/g, (_, e) => {
    const v = lookup(scope, e);
    return v == null ? '' : String(v);
  });
}
function renderNode(node, scope, parent) {
  if (node.nodeType === 3) { parent.appendChild(document.createTextNode(interp(scope, node.nodeValue))); return; }
  if (node.nodeType !== 1) return;
  const tag = node.localName;
  if (tag === 'helmet') return;
  if (tag === 'sc-for') {
    const list = lookup(scope, node.getAttribute('list').replace(/^\\{\\{|\\}\\}$/g, '')) || [];
    const as = node.getAttribute('as') || 'item';
    list.forEach((item, i) => {
      const s2 = Object.assign({}, scope, { [as]: item, $index: i });
      node.childNodes.forEach((c) => renderNode(c, s2, parent));
    });
    return;
  }
  if (tag === 'sc-if') {
    const v = lookup(scope, node.getAttribute('value').replace(/^\\{\\{|\\}\\}$/g, ''));
    if (v) node.childNodes.forEach((c) => renderNode(c, scope, parent));
    return;
  }
  const el = node.namespaceURI && node.namespaceURI !== 'http://www.w3.org/1999/xhtml'
    ? document.createElementNS(node.namespaceURI, node.localName)
    : document.createElement(node.localName);
  for (const a of Array.from(node.attributes)) {
    if (/^on/i.test(a.name)) continue;
    if (a.name.startsWith('hint-')) continue;
    const whole = a.value.match(/^\\{\\{([^}]+)\\}\\}$/);
    let v = whole ? lookup(scope, whole[1]) : interp(scope, a.value);
    if (v === undefined || v === null || v === false) { if (whole && v === false && a.name.startsWith('aria-')) el.setAttribute(a.name, 'false'); continue; }
    el.setAttribute(a.name, String(v));
  }
  const kids = node.localName === 'template' ? node.content.childNodes : node.childNodes;
  kids.forEach((c) => renderNode(c, scope, el));
  parent.appendChild(el);
}
window.__renderDC = function (templateHtml, classCode, props) {
  const Component = new Function('DCLogic', classCode + '\\n;return Component;')(DCLogic);
  const inst = new Component(props);
  const vals = inst.renderVals();
  const tpl = document.createElement('template');
  tpl.innerHTML = templateHtml;
  const root = document.getElementById('root');
  tpl.content.childNodes.forEach((c) => renderNode(c, vals, root));
};
`;

(async () => {
  fs.mkdirSync(outDir, { recursive: true });
  const browser = await chromium.launch();
  for (const f of files) {
    const src = fs.readFileSync(path.join(projectDir, f), 'utf8');
    const xdc = src.match(/<x-dc>([\s\S]*)<\/x-dc>/)[1];
    const helmetCss = (xdc.match(/<helmet>[\s\S]*?<style>([\s\S]*?)<\/style>[\s\S]*?<\/helmet>/) || [, ''])[1];
    const template = xdc.replace(/<helmet>[\s\S]*?<\/helmet>/, '');
    const scriptTag = src.match(/<script type="text\/x-dc"[^>]*data-props='([^']*)'[^>]*>([\s\S]*?)<\/script>/);
    const propsDef = JSON.parse(scriptTag[1].replace(/&#39;/g, "'").replace(/&amp;/g, '&'));
    const props = {};
    for (const [k, v] of Object.entries(propsDef)) if (!k.startsWith('$') && v && 'default' in v) props[k] = v.default;
    const preview = propsDef.$preview || { width: 1440, height: 900 };
    const page = await browser.newPage({ viewport: { width: preview.width, height: preview.height }, deviceScaleFactor: 1 });
    await page.setContent(`<!doctype html><html lang="nl"><head><meta charset="utf-8"><style>body{margin:0;font-family:Inter,system-ui,sans-serif}${helmetCss}</style></head><body><div id="root"></div><script>${runtime}</script></body></html>`);
    await page.evaluate(([t, c, p]) => window.__renderDC(t, c, p), [template, scriptTag[2], props]);
    await page.waitForTimeout(300);
    const out = path.join(outDir, f.replace('.dc.html', '.png'));
    await page.screenshot({ path: out, fullPage: true });
    console.log('ok', out);
    await page.close();
  }
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
