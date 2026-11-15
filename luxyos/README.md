# LuxyOS

Werkmap voor LuxyOS: een snel, gratis en eerlijk besturingssysteem. De domeinen luxyos.com, luxyos.nl en luxyos.eu zijn vastgelegd.

LuxyOS is een project van Nijaz Omanovic. Eigen ontwerp, niets gekopieerd van anderen; aan de plannen kunnen geen rechten worden ontleend. Zie "Eigendom en originaliteit" in de [bouwnota](bouwnota.md).

Er wordt hier nog niet gebouwd. Deze map bewaart de ideeën, de ontwerpen en het plan om te beginnen.

## Inhoud

| Map of bestand | Wat erin staat |
| --- | --- |
| [`bouwnota.md`](bouwnota.md) | De volledige bouwnota: visie, techniek, functies, doelgroepen en bouwvolgorde |
| [`ideeen/hoe-beginnen.md`](ideeen/hoe-beginnen.md) | Ideeën en stappenplan om te beginnen met bouwen |
| [`afbeeldingen/`](afbeeldingen/) | Afbeeldingen van alle ontwerpen en twee schema's |
| [`ontwerpen/`](ontwerpen/) | De bronbestanden van de ontwerpen, plus een script om ze opnieuw als afbeelding te maken |
| [`website/`](website/) | De "Coming soon"-pagina voor luxyos.com in 11 talen, Engels als standaard |
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
| 21 | [Verkenner: vertrouwde indeling, zoals in Windows](afbeeldingen/21-verkenner.png) |
| 22 | [Sponsorformulier: kiezen vóór het betalen (later, met zakelijk PayPal-account)](afbeeldingen/22-sponsorformulier-voorbeeld.png) |
| 23 | [Netwerk en internet: wifi, VPN, IP-instellingen, versleutelde DNS, firewall per app](afbeeldingen/23-netwerk.png) |
| 24 | [Accounts: Active Directory voor werk, Microsoft 365, Google en Yahoo](afbeeldingen/24-accounts.png) |
| 25 | [Beveiliging met ingebouwde IT DeXt Antivirus](afbeeldingen/25-beveiliging.png) |

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

De website staat live op https://luxyos.com/ in 11 talen: Engels (standaard), Nederlands, Duits, Frans, Spaans, Kroatisch, Bosnisch, Servisch, Albanees, Macedonisch en Turks. Elke taal heeft een eigen map (`website/de/`, `website/fr/` enz.); het taalmenu rechtsboven werkt zonder JavaScript. Alle pagina's worden gemaakt met `website/src/build.py`; pas teksten daar aan en draai `python3 website/src/build.py`. Nederlands toont Nederlandse afbeeldingen, de andere talen Engelse. Er is een blok "We zoeken ontwikkelaars en sponsors" met een knop naar GitHub en de knop "Donatie LuxyOS" (vrijwillige donatie, paypal.me/NOmanovic), en het doel: een eerste testversie in 2027. De pagina's laden niets van andere websites: geen lettertypen, scripts, trackers of cookies. luxyos.nl en luxyos.eu verwijzen nog niet door; daarvoor moet hun DNS eerst naar de View365-server.

## Afbeeldingen opnieuw maken

Na een wijziging in een ontwerp:

```
node ontwerpen/render-naar-png.js ontwerpen afbeeldingen-nieuw Main.dc.html Gaming.dc.html
```

Dit vraagt Node.js en Playwright met Chromium.
