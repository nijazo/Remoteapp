# CLAUDE.md — remoteapp.nl Codebase Guide

> Dit bestand is bedoeld om AI-assistenten (Claude, Copilot, etc.) te oriënteren in deze repository. Het behandelt architectuur, conventies, workflows en belangrijke patronen.

---

## Projectoverzicht

**remoteapp.nl** is een open-source platform voor remote control en remote scripting, gebouwd met .NET 9, ASP.NET Core Blazor (server-side), SignalR Core en WebRTC. Het stelt IT-professionals in staat om desktops op afstand te besturen en scripts uit te voeren op beheerde machines.

---

## Repository-structuur

```
remoteapp.nl/
├── Server/                  # ASP.NET Core 9 Blazor Server webapplicatie
│   ├── API/                 # REST API controllers
│   ├── Areas/               # Razor Pages / Identity
│   ├── Components/          # Blazor components
│   ├── Data/                # EF Core DbContext en migraties
│   ├── Hubs/                # SignalR hubs (AgentHub, CasterHub, ViewerHub)
│   ├── Pages/               # Razor Pages en Blazor pages
│   ├── Services/            # Server-side services (DI)
│   └── wwwroot/             # Statische assets (TypeScript gecompileerd naar JS)
│       └── src/RemoteControl/  # TypeScript remote control client
├── Agent/                   # Cross-platform service agent voor beheerde apparaten
│   └── Services/            # Agent services (PowerShell, updater, etc.)
├── Desktop.Core/            # Gedeelde desktop client logica
├── Desktop.Win/             # Windows desktop client (WPF + SharpDX)
├── Desktop.XPlat/           # Cross-platform desktop client (Avalonia)
├── Shared/                  # Gedeelde modellen, DTO's en utilities
│   └── Models/              # Entiteitsmodellen en DTO's
├── Tests/                   # Unit tests (MSTest + Moq)
├── Tests.LoadTester/        # Load testing utilities
├── Server.Installer/        # Cross-platform server installer CLI-tool
├── Agent.Installer.Win/     # Windows agent installer
├── Utilities/               # PowerShell build/migratie/publish scripts
└── .github/workflows/       # GitHub Actions CI/CD
```

---

## Tech Stack

| Laag | Technologie |
|---|---|
| Runtime | .NET 9.0 |
| Web framework | ASP.NET Core 9, Blazor Server |
| Real-time communicatie | ASP.NET Core SignalR (MessagePack protocol) |
| ORM | Entity Framework Core 9 |
| Databases | SQLite (standaard), SQL Server, PostgreSQL |
| Windows desktop | WPF, SharpDX |
| Cross-platform desktop | Avalonia UI 11.2.3 |
| WebRTC | Microsoft.MixedReality.WebRTC 2.0.2 |
| Scripting | Microsoft PowerShell SDK 7.5.0 |
| Frontend | TypeScript (ES2017), gecompileerd via npm/webpack |
| Testing | MSTest 3.x, Moq 4.20.x, EF Core InMemory |

---

## Architectuurconcepten

### Multi-Tenancy

- Het platform ondersteunt meerdere **Organisaties**. `MaxOrganizationCount` in `ApplicationOptions` bepaalt het maximum (standaard: 1).
- Elke organisatie heeft eigen apparaten, gebruikers, apparaatgroepen, scripts en branding.
- Gebruikersrollen: **Server Admin**, **Organisatie Admin** en **standaardgebruiker**.

### Real-Time Communicatie (SignalR)

Drie hubs in `Server/Hubs/`:

| Hub | Doel |
|---|---|
| `AgentHub` | Persistente verbinding van elke beheerde Agent naar de server |
| `CasterHub` | Verbinding van de Desktop client (schermzender) naar de server |
| `ViewerHub` | Verbinding van de browser (schermkijker) naar de server |

SignalR gebruikt het **MessagePack** binaire protocol voor efficiëntie. Maximale berichtgrootte is 100 KB (geconfigureerd in `Startup.cs`).

### Remote Control Flow

```
Desktop Client (CasterHub) ──► Server ──► Browser (ViewerHub)
         ▲                                        │
         └────── WebRTC (peer-to-peer, Windows) ──┘
```

- Op Windows wordt WebRTC gebruikt voor directe peer-to-peer schermstreaming.
- De server stuurt frames door wanneer WebRTC niet beschikbaar is (Linux/macOS desktop clients).

### Agent Werking

- Elke beheerde machine draait de **Agent** service.
- De agent verbindt met de server via `AgentHub` en:
  - Verstuurt periodieke heartbeats en apparaatinfo-updates.
  - Controleert op openstaande script runs.
  - Accepteert remote control sessieverzoeken.
  - Werkt zichzelf bij via de `Updater` service.

### Datalaag

- EF Core met aparte `DbContext` subklassen per provider:
  - `SqliteDbContext` → `Remoteapp.db`
  - `SqlServerDbContext`
  - `PostgreSqlDbContext`
- `DBProvider` in `ApplicationOptions` selecteert de actieve provider.
- Alle datatoegang verloopt via `IDataService` / `DataService` (DI singleton).
- Migraties staan in `Server/Data/Migrations/`.

---

## Projectconventies

### C# Stijl

- Gebruik `var` voor alle lokale variabelen waar het type duidelijk of ingebouwd is (geconfigureerd via `.editorconfig`).
- XML doc comments (`CS1591`) zijn onderdrukt — voeg ze niet toe tenzij expliciet gevraagd.
- Platform-compatibility analyzer (`CA1416`) is project-breed onderdrukt; gebruik `[SupportedOSPlatform]` voor nieuwe platform-specifieke code.
- Dependency injection wordt overal gebruikt — vermijd `new`-ing van services; registreer ze in `Startup.cs`.

### Naamgeving

- Modellen/entiteiten: PascalCase zelfstandige naamwoorden (bijv. `Device`, `RemoteappUser`, `Organization`).
- Services: interface + implementatiepatroon (`IDataService` / `DataService`).
- SignalR hub methodenamen: PascalCase werkwoorden (bijv. `SendHeartbeat`, `UpdateDevice`).
- API controllers: `{Resource}Controller` (bijv. `DevicesController`).

### Databasewijzigingen

Bij het wijzigen van EF Core modellen:

1. Bewerk het model in `Shared/Models/` of `Server/Data/`.
2. Voer `Add-Migration.ps1` uit (in `Utilities/`) of gebruik:
   ```bash
   dotnet ef migrations add <MigratieNaam> --project Server
   ```
3. Migraties worden automatisch uitgevoerd bij opstarten via `AppDb.MigrateAndSeed()`.

### Configuratie

- `appsettings.json` — basisconfiguratie (ingecheckt in source).
- `appsettings.Production.json` — productie-overrides (**niet** in source; aangemaakt bij deployment).
- Alle app-instellingen staan onder de `ApplicationOptions` sleutel en mappen naar `ApplicationOptions.cs`.
- Sla nooit geheimen (SMTP-wachtwoorden, connectiestrings met credentials) op in source.

### Frontend (TypeScript)

- Source staat in `Server/wwwroot/src/`.
- Gecompileerde output gaat naar `Server/wwwroot/build/`.
- Bouw TypeScript met `npm run build` (of `npm run watch` tijdens ontwikkeling) vanuit `Server/wwwroot/`.
- De remote control viewer client staat in `Server/wwwroot/src/RemoteControl/`.

---

## Bouwen & Draaien

### Vereisten

- .NET 5 SDK
- Node.js / npm (voor TypeScript frontend)
- Visual Studio 2019+ of VS Code met C# extensie

### Lokale Ontwikkeling

```bash
# Herstel dependencies
dotnet restore

# Bouw TypeScript
cd Server/wwwroot
npm install
npm run build
cd ../..

# Draai de server (SQLite standaard)
dotnet run --project Server
```

Server draait standaard op `https://localhost:5001`.

### Tests Uitvoeren

```bash
dotnet test
```

Tests draaien vanuit `Tests/Tests.csproj`. De testsuite gebruikt:
- MSTest als framework
- Moq voor mocking
- EF Core InMemory provider om een echte database te vermijden

### Platform Clients Bouwen

Omdat de Windows agent Windows vereist en de macOS agent macOS, gebruik **GitHub Actions** voor volledige builds:

- **`/.github/workflows/build.yml`** — volledige multi-platform build (workflow dispatch, accepteert `ServerUrl` en `ServerRid` invoer)
- **`/.github/workflows/run_tests.yml`** — draait `dotnet test` bij elke push/PR naar `master`

Lokaal bouwen voor een enkel platform:
```bash
# Windows agent (x64)
dotnet publish Agent -r win-x64 -c Release

# macOS agent
dotnet publish Agent -r osx-x64 -c Release

# Linux agent
dotnet publish Agent -r linux-x64 -c Release
```

### Publiceren / Release

Gebruik `Utilities/Publish.ps1` voor het verpakken van release-artefacten.

---

## API Referentieoverzicht

De REST API is gedocumenteerd op `/swagger` wanneer de server draait.

**Authenticatie:** Voeg `[ApiToken]:[ApiSecret]` toe aan de `Authorization` header.

Belangrijke controllers in `Server/API/`:

| Controller | Verantwoordelijkheid |
|---|---|
| `DevicesController` | Apparaten opvragen/beheren |
| `ScriptingController` | Scripts uitvoeren op apparaten |
| `ScriptResultsController` | Resultaten van scriptuitvoering ophalen |
| `SavedScriptsController` | CRUD voor opgeslagen scripts |
| `RemoteControlController` | Remote control sessies starten |
| `AlertsController` | Meldingen aanmaken/beheren |
| `OrganizationManagementController` | Organisatiegebruikers, uitnodigingen, groepen beheren |
| `FileSharingController` | Bestanden uploaden/downloaden |
| `AgentUpdateController` | Agent-updates pushen |
| `ClientDownloadsController` | Agent/client installers aanbieden |

---

## Belangrijke Bestanden

| Bestand | Doel |
|---|---|
| `Remoteapp.sln` | Visual Studio oplossing — startpunt voor het bouwen van alle projecten |
| `Server/Startup.cs` | DI-registratie, middleware pipeline, SignalR config |
| `Server/Data/AppDb.cs` | Basis EF Core DbContext met alle entiteitssets |
| `Server/Services/DataService.cs` | Hoofd datatoegangsservice |
| `Server/Hubs/AgentHub.cs` | Agent ↔ Server SignalR hub |
| `Server/Hubs/CasterHub.cs` | Desktop ↔ Server SignalR hub |
| `Server/Hubs/ViewerHub.cs` | Browser ↔ Server SignalR hub |
| `Shared/Models/Device.cs` | Kern apparaat-entiteit |
| `Shared/Models/Organization.cs` | Kern organisatie-entiteit |
| `Shared/Models/RemoteappUser.cs` | Gebruikersentiteit (breidt ASP.NET Identity uit) |
| `Agent/Services/AgentSocket.cs` | SignalR verbindingsbeheerder van de Agent |
| `Server/appsettings.json` | Basisconfiguratie van de applicatie |
| `.editorconfig` | C# codestijlregels |
| `Utilities/Add-Migration.ps1` | Helper voor EF Core migraties |

---

## CI/CD

| Workflow | Trigger | Runner | Doel |
|---|---|---|---|
| `run_tests.yml` | Push / PR naar `master` | `windows-latest` | `dotnet test` uitvoeren |
| `build.yml` | Handmatig starten | `windows-latest` + `macos-10.15` | Volledige multi-platform build met code signing |

Build-artefacten (agents, installers) worden per run geüpload. De `build.yml` workflow accepteert:
- `ServerUrl` — ingebakken in agent/client binaries tijdens compilatie
- `ServerRid` — .NET runtime identifier voor de server (bijv. `linux-x64`)

---

## Docker

Er is een `Dockerfile` beschikbaar voor gecontaineriseerde serverdeployment:

- Basisimage: `ubuntu:focal` met .NET 5 runtime
- Datamap: `/remoteapp-data/` (koppel als volume)
- Standaard database: `/remoteapp-data/Remoteapp.db`
- Opstartscript: `DockerMain.sh`

```bash
docker run -d \
  -p 5000:5000 \
  -v /jouw/data:/remoteapp-data \
  translucency/remoteapp
```

---

## Veelvoorkomende Taken voor AI-Assistenten

### Een nieuw API-eindpunt toevoegen
1. Maak of breid een controller uit in `Server/API/`.
2. Gebruik constructor-injectie voor `IDataService`, `ILogger`, etc.
3. Decoreer met `[Authorize]` en passend rolbeleid.
4. Voeg Swagger-annotaties toe als het eindpunt extern toegankelijk is.

### Een nieuw SignalR-bericht toevoegen
1. Definieer de methode in de juiste hub (`AgentHub`, `CasterHub`, of `ViewerHub`).
2. Voeg de bijbehorende client-side handler toe in de agent (`AgentSocket.cs`) of de TypeScript client.
3. Als het bericht gestructureerde data bevat, definieer een DTO in `Shared/Models/`.

### Een nieuwe database-entiteit toevoegen
1. Voeg de modelklasse toe aan `Shared/Models/`.
2. Voeg een `DbSet<T>` toe aan `Server/Data/AppDb.cs`.
3. Configureer relaties in `AppDb.OnModelCreating()` indien nodig.
4. Genereer en pas een migratie toe (zie Databasewijzigingen).

### ApplicationOptions wijzigen
1. Voeg de eigenschap toe aan `Server/Models/ApplicationOptions.cs`.
2. Voeg de bijbehorende entry toe aan `appsettings.json` met een zinvolle standaardwaarde.
3. Documenteer nieuwe opties in de README onder het configuratiegedeelte.

### Werken met de TypeScript frontend
- De TypeScript-broncode gebruikt ES2017 modules.
- `ViewerHubConnection.ts` beheert de SignalR-verbinding vanuit de browser.
- `DtoMessageHandler.ts` verwerkt binnenkomende binaire DTO-berichten.
- `RtcSession.ts` beheert de WebRTC peer-verbinding.
- Hercompileer na wijzigingen met `npm run build` vanuit `Server/wwwroot/`.
