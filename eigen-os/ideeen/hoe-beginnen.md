# Hoe beginnen

Ideeën en stappenplan voor het moment dat het bouwen begint. Nog niets hiervan is gebouwd.

## Uitgangspunt

- Een doelgroep gaat pas open als alles op zijn lijst werkt. Eerst privé, dan zakelijk kantoorwerk, dan gamers, dan techniek en industrie.
- Eerst testen in een virtuele machine, daarna pas op een echte computer.
- Alleen een lege test-pc gebruiken, nooit een pc met belangrijke gegevens.

## Stappenplan

| Stap | Wat | Resultaat | Waar |
| --- | --- | --- | --- |
| 1 | Bouwscript in Docker | Een minimaal opstartbaar image: Linux-kernel, een eerste versie van de broker en een eenvoudige shell | Repository |
| 2 | Automatische test in QEMU | Het image start vanzelf op en een test controleert dat de broker draait | Repository en cloud |
| 3 | Hardware-rapport | Een programma dat laat zien wat er in een pc zit en welke drivers ontbreken | Repository |
| 4 | USB-stick met agent | Een lege pc opstarten vanaf USB, het hardware-rapport draaien, en Claude Code op die pc starten (`claude remote-control`) zodat Claude direct mee kan werken | Echte test-pc |
| 5 | Installatieprogramma | Het systeem van de USB-stick op de schijf zetten: partities, versleuteling, bootloader | Eerst QEMU, dan test-pc |

Daarna volgen de fasen uit de bouwnota: bureaublad, Wine, app-winkel, enzovoort.

## De agent op de USB-stick

- Een cloudsessie kan niet zelf bij een pc thuis. De agent draait daarom op de pc zelf en maakt verbinding naar buiten.
- Op de stick: netwerk (eerst met een kabel, want wifi heeft drivers nodig), Claude Code, en de hulpmiddelen om schijven en hardware te bekijken.
- Stappen die een schijf wissen gebeuren alleen na bevestiging van de eigenaar.

## Voorstel voor de mapindeling als het bouwen begint

```
eigen-os/
  bouwen/          bouwscripts en Dockerfile voor het image
  broker/          de eigen opstartdienst (Rust)
  hardware/        hardware-rapport en driverhulp
  installatie/     installatieprogramma en overstap-assistent
  bureaublad/      eigen bureaublad (Qt 6)
  tests/           automatische tests in QEMU
```

## Gereedschap

| Taak | Gereedschap |
| --- | --- |
| Image bouwen | Docker, Buildroot of Yocto |
| Testen | QEMU met KVM, later openQA voor automatisch door het systeem klikken |
| Eigen onderdelen | Rust (broker, winkel, instellingen), Qt 6 (bureaublad) |
| Windows-programma's | Wine, DXVK, VKD3D-Proton |
| Automatische tests bij elke wijziging | GitHub Actions |

## Nog te beslissen voor de start

- [ ] Naam van het OS
- [ ] Licentie voor de eigen code
- [ ] Welke test-pc(s) gebruiken we: liefst een gewone laptop met Intel of AMD
- [ ] Wie bouwt mee: team en eventuele financiering
