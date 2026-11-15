# Eigen OS (werknaam)

Werkmap voor het eigen besturingssysteem. De naam volgt later; tot die tijd heet alles "eigen OS".

Er wordt hier nog niet gebouwd. Deze map bewaart de ideeën, de ontwerpen en het plan om te beginnen.

## Inhoud

| Map of bestand | Wat erin staat |
| --- | --- |
| [`bouwnota.md`](bouwnota.md) | De volledige bouwnota: visie, techniek, functies, doelgroepen en bouwvolgorde |
| [`ideeen/hoe-beginnen.md`](ideeen/hoe-beginnen.md) | Ideeën en stappenplan om te beginnen met bouwen |
| [`afbeeldingen/`](afbeeldingen/) | Afbeeldingen van alle ontwerpen en twee schema's |
| [`ontwerpen/`](ontwerpen/) | De bronbestanden van de ontwerpen, plus een script om ze opnieuw als afbeelding te maken |

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

Schema's: [opbouw van het systeem](afbeeldingen/diagram-opbouw-systeem.png) en [bouwvolgorde](afbeeldingen/diagram-bouwvolgorde.png).

Namen van apps, bedrijven, aantallen en tijden in de ontwerpen zijn voorbeelden. Het rondje op de Start-knop is een tijdelijk logo.

## Afbeeldingen opnieuw maken

Na een wijziging in een ontwerp:

```
node ontwerpen/render-naar-png.js ontwerpen afbeeldingen-nieuw Main.dc.html Gaming.dc.html
```

Dit vraagt Node.js en Playwright met Chromium.
