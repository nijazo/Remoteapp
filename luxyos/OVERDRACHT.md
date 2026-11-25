> **Nieuwe versie:** deze overdracht staat nu in het LuxyOS-project: https://github.com/nijazo/luxyos/blob/main/docs/nl/overdracht.md. Zet Remoteapp niet op de pc; alleen het LuxyOS-project is nodig.

# Overdracht: verder werken aan LuxyOS op de eigen pc

Stand van 25 november 2026. Dit bestand vat samen wat er in de cloud-chat "LuxyOS" is gedaan, zodat een nieuwe chat op de pc (D:\LuxyOS) kan verdergaan.

## Waar alles staat

| Wat | Waar |
| --- | --- |
| Openbare projectpagina: plan, ontwerpen, besluiten, website-bron | github.com/nijazo/luxyos, branch `main` |
| Nederlandse werkmap: bouwnota, afbeeldingen, ontwerpbronnen (.dc.html), logo's | github.com/nijazo/Remoteapp, branch `ccr-e51dc20e-zfaiie`, map `luxyos/` |
| Bouwnota (Claude Docs) | https://claude.ai/artifact/YR2YhQsEPBiL3BuKbhc3b7 |
| Ontwerpcanvas | https://claude.ai/artifact/JwzWQCLH1UPPJX8NKsiANe |
| Website | luxyos.com, 11 talen |

De bouwnota staat op drie plekken en moet gelijk blijven: Claude Docs, `luxyos/docs/nl/bouwnota.md` en `Remoteapp/luxyos/bouwnota.md`. Het enige verschil is het pad naar afbeeldingen (`design/` en `afbeeldingen/`).

## Afspraken

- Commits staan op naam van Nijaz Omanovic, met het GitHub-noreply-adres. Geen regels over Claude in commits.
- Engels is de standaard op GitHub. Nederlandse versies staan in `docs/nl/`.
- Licenties: GPL-3.0 voor het systeem, Apache-2.0 voor de SDK, CC BY 4.0 voor documenten en ontwerpen. Naam en logo zijn merken.
- LuxyOS is gratis en niet-commercieel. De winkel is gratis, zonder commissie, en regelt geen betalingen.
- Doneren: https://paypal.me/NOmanovic ("Donatie LuxyOS", altijd vrijwillig).
- Namen van donateurs en sponsors nooit in Git. De lijst staat alleen op de server.
- EU-wetgeving is de basis in elk land.

## Website luxyos.com

- Bron: `luxyos/website`. `src/build.py` maakt de pagina's in 11 talen. Afbeeldingen in `website/img` als WebP (720 en 1440 pixels breed), Engels en Nederlands.
- Live zetten gebeurt door de chat "View365" (Remote Control op de pc): `build.py` en nieuwe afbeeldingen naar de server, daar bouwen met de privélijst van sponsors. Nooit de `index.html`-bestanden uit Git over de live site zetten, want dan verdwijnen de sponsors.
- Laatste live versie: commit `388cfcb` (afbeeldingen over AI en webbescherming). 5 sponsors staan erop.
- Elke wijziging eerst controleren op telefoon en computer, in alle 11 talen.

## Ontwerpen

- `docs/design/01` tot en met `27` (Engels) en `docs/nl/design/` (Nederlands).
- Bronnen staan als `.dc.html` in `Remoteapp/luxyos/ontwerpen/`. Ze worden naar PNG gezet met Playwright.
- Nieuwste: 26 AI (helemaal uit te zetten) en 27 webbescherming van IT DeXt Antivirus.
- Sociale media en LinkedIn: `luxyos/brand/social/` en `luxyos/brand/social/linkedin/`.

## Recente besluiten

- **AI**: de gebruiker kiest uit, alleen op deze computer, of aan. Met AI uit werkt AI nergens: niet in het systeem, niet in apps en niet online. Op het werk kan de beheerder dit vastzetten.
- **Webbescherming**: IT DeXt Antivirus blokkeert websites met schadelijk JavaScript, controleert elk uur opnieuw en geeft ze vrij als ze schoon zijn.
- **App-winkel** (besluit 0012, `docs/store.md`): start via GitHub met een manifest per app. IT DeXt beoordeelt. Gratis apps: GitHub-account met tweestapsverificatie. Betaalde apps: ook handelaarsgegevens (DSA). Domeinen en servers komen later.

## Besproken, nog niet besloten

**Windows-programma's installeren zoals in Windows.** Via Wine, onzichtbaar voor de gebruiker:
- één C-schijf met `Program Files`, `Program Files (x86)`, `Windows` en `Gebruikers`;
- het installatieprogramma stelt `C:\Program Files\...` voor;
- Documenten op C: is dezelfde map als in LuxyOS;
- usb-sticks krijgen een letter, de Z-schijf wordt verborgen;
- verwijderen via Instellingen › Apps.

Voorstel: één gedeelde C-schijf voor alle Windows-programma's, zoals Windows. IT DeXt scant elke .exe voordat die start, de hele Windows-laag draait afgeschermd, en programma's van een onbekende bron gaan apart. Nog doen: in de bouwnota zetten (daar staat nu "elk programma in een eigen afgeschermde omgeving") en een ontwerp maken van de Verkenner met `C:\Program Files`.

Ook besproken: zonder Wine kan het alleen met een echte Windows op de achtergrond (Windows-licentie nodig). Zonder Linux is er geen haalbare basis voor 2027. Advies: Linux-kern onzichtbaar houden, Wine als standaard.

## Open punten

- DNS van luxyos.nl en luxyos.eu naar de View365-server laten wijzen.
- GitHub-instellingen: About-tekst, website, onderwerpen, Discussions, private vulnerability reporting, Sponsorships.
- App-winkel: hoe IT DeXt beoordeelt, domeinen, e-mailadres voor ontwikkelaars, naam van de winkel-repository.
- Keuze over de C-schijf (zie hierboven).
- Vertalingen van de website laten nakijken door moedertaalsprekers.

## Starten op de pc

Mappen op de pc:

| Map | Wat |
| --- | --- |
| `D:\LuxyOS\git` | De twee projecten van GitHub |
| `D:\LuxyOS\chat` | Werkmap voor de Claude-chat |

In PowerShell:

```
mkdir D:\LuxyOS\git, D:\LuxyOS\chat
cd D:\LuxyOS\git
git clone https://github.com/nijazo/luxyos.git
git clone -b ccr-e51dc20e-zfaiie https://github.com/nijazo/Remoteapp.git
Copy-Item D:\LuxyOS\git\Remoteapp\luxyos\chat-map\* D:\LuxyOS\chat\ -Recurse -Force
```

Staan de projecten er al, haal dan de nieuwste versie op met `git pull` in elke map, en voer alleen de laatste regel (`Copy-Item`) uit.

Daarmee staan in `D:\LuxyOS\chat`:

- `CLAUDE.md`: vertelt de chat waar de projecten staan, de werkafspraken, en laadt deze overdracht automatisch;
- `.claude\settings.json`: geeft de chat toegang tot `D:\LuxyOS\git`.

Open daarna in de Claude-app een nieuwe Claude Code-chat met de map `D:\LuxyOS\chat`, of typ `claude` in PowerShell in die map. Begin met: "Ga verder met LuxyOS."
