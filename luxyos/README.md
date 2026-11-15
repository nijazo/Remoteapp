# LuxyOS

Werkmap voor LuxyOS: een snel, gratis en eerlijk besturingssysteem. De domeinen luxyos.com, luxyos.nl en luxyos.eu zijn vastgelegd.

Er wordt hier nog niet gebouwd. Deze map bewaart de ideeën, de ontwerpen en het plan om te beginnen.

## Inhoud

| Map of bestand | Wat erin staat |
| --- | --- |
| [`bouwnota.md`](bouwnota.md) | De volledige bouwnota: visie, techniek, functies, doelgroepen en bouwvolgorde |
| [`ideeen/hoe-beginnen.md`](ideeen/hoe-beginnen.md) | Ideeën en stappenplan om te beginnen met bouwen |
| [`afbeeldingen/`](afbeeldingen/) | Afbeeldingen van alle ontwerpen en twee schema's |
| [`ontwerpen/`](ontwerpen/) | De bronbestanden van de ontwerpen, plus een script om ze opnieuw als afbeelding te maken |
| [`website/`](website/) | De "Binnenkort"-pagina voor luxyos.com |
| [`logo/`](logo/) | Het logo: Ring van licht, als SVG, witte versie, app-icoon en animatie |

## De ontwerpen

| Nr. | Scherm |
| --- | --- |
| 01 | [Bureaublad met startmenu](afbeeldingen/01-bureaublad-startmenu.png) |
| 02 | [Eerste start: jouw keuzes (browser, zoekmachine, beveiliging)](afbeeldingen/02-eerste-start-keuzes.png) |
| 03 | [App-winkel met toestemmingen](afbeeldingen/03-app-winkel-toestemmingen.png) |
| 04 | [Privacyoverzicht](afbeeldingen/04-privacyoverzicht.png) |
| 05 | [Herstel en versleuteling](afbeeldingen/05-herstel-en-versleuteling.png) |
| 06 | [App-winkel: Windows-programma's](afbeeldingen/06-app-winkel-windows-programmas.png) |
| 07 | [Overstap-assistent: controlerapport](afbeeldingen/07-overstap-controlerapport.png) |
| 08 | [Overstap-assistent: bezig met overstappen](afbeeldingen/08-overstap-voortgang.png) |
| 09 | [Batterijoverzicht](afbeeldingen/09-batterijoverzicht.png) |
| 10 | [Apparaatbeheer](afbeeldingen/10-apparaatbeheer.png) |
| 11 | [Aanmeldscherm (lokale gebruikers)](afbeeldingen/11-aanmeldscherm.png) |
| 12 | [Gaming-instellingen](afbeeldingen/12-gaming-instellingen.png) |
| 13 | [Website: Werkt jouw game?](afbeeldingen/13-website-werkt-jouw-game.png) |
| 14 | [Extern bureaublad: instellingen op de server](afbeeldingen/14-extern-bureaublad-instellingen.png) |
| 15 | [Extern bureaublad: zo ziet de klant het](afbeeldingen/15-extern-bureaublad-klant.png) |
| 16 | [Extern bureaublad-app: verbinden met Windows](afbeeldingen/16-extern-bureaublad-app.png) |
| 17 | [Logo-ideeën voor LuxyOS](afbeeldingen/17-logo-ideeen.png) |
| 18 | [Website: Binnenkort](afbeeldingen/18-website-binnenkort.png) ([mobiel](afbeeldingen/19-website-binnenkort-mobiel.png)) |
| 20 | [Logo: Ring van licht, uitgewerkt met animatie](afbeeldingen/20-logo-ring-van-licht.png) |

Schema's: [opbouw van het systeem](afbeeldingen/diagram-opbouw-systeem.png) en [bouwvolgorde](afbeeldingen/diagram-bouwvolgorde.png).

Namen van apps, bedrijven, aantallen en tijden in de ontwerpen zijn voorbeelden.

## Logo

Het gekozen logo is de **Ring van licht**: de ring laadt alleen waar het nodig is, daarna gaat het zonnetje aan.

| Bestand | Gebruik |
| --- | --- |
| [`logo/luxyos-logo.svg`](logo/luxyos-logo.svg) | Logo op een lichte achtergrond |
| [`logo/luxyos-logo-wit.svg`](logo/luxyos-logo-wit.svg) | Logo op een donkere achtergrond |
| [`logo/luxyos-app-icoon.svg`](logo/luxyos-app-icoon.svg) en [`-512.png`](logo/luxyos-app-icoon-512.png) | App-icoon |
| [`logo/luxyos-logo-animatie.svg`](logo/luxyos-logo-animatie.svg) | Animatie: de ring laadt in 1,1 s, de zon gaat aan op 1,6 s |

Kleuren: Zon `#F5A524`, Nacht `#13243B`, Hemel `#2563C9`.

## De Binnenkort-pagina online zetten

[`website/index.html`](website/index.html) is één bestand zonder externe onderdelen: geen lettertypen, scripts, trackers of cookies van andere websites. Zet het als `index.html` in de hoofdmap van de webhosting voor luxyos.com, en laat luxyos.nl en luxyos.eu daarnaar doorverwijzen. De pagina past zich aan voor telefoons en voor de donkere modus.

## Afbeeldingen opnieuw maken

Na een wijziging in een ontwerp:

```
node ontwerpen/render-naar-png.js ontwerpen afbeeldingen-nieuw Main.dc.html Gaming.dc.html
```

Dit vraagt Node.js en Playwright met Chromium.
