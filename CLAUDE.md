# CLAUDE.md — Remotely Codebase Guide

> This file is intended to orient AI assistants (Claude, Copilot, etc.) working in this repository. It covers architecture, conventions, workflows, and key patterns.

---

## Project Overview

**Remotely** is an open-source remote control and remote scripting platform built with .NET 5, ASP.NET Core Blazor (server-side), SignalR Core, and WebRTC. It allows IT professionals to remotely control desktops and execute scripts on managed machines.

---

## Repository Structure

```
Remotely/
├── Server/                  # ASP.NET Core 5 Blazor Server web application
│   ├── API/                 # REST API controllers
│   ├── Areas/               # Razor Pages / Identity
│   ├── Components/          # Blazor components
│   ├── Data/                # EF Core DbContext and migrations
│   ├── Hubs/                # SignalR hubs (AgentHub, CasterHub, ViewerHub)
│   ├── Pages/               # Razor Pages and Blazor pages
│   ├── Services/            # Server-side services (DI)
│   └── wwwroot/             # Static assets (TypeScript compiled to JS)
│       └── src/RemoteControl/  # TypeScript remote control client
├── Agent/                   # Cross-platform managed-device service agent
│   └── Services/            # Agent services (PowerShell, updater, etc.)
├── Desktop.Core/            # Shared desktop client logic
├── Desktop.Win/             # Windows desktop client (WPF + SharpDX)
├── Desktop.XPlat/           # Cross-platform desktop client (Avalonia)
├── Shared/                  # Shared models, DTOs, utilities used by all projects
│   └── Models/              # Entity models and DTOs
├── Tests/                   # Unit tests (MSTest + Moq)
├── Tests.LoadTester/        # Load testing utilities
├── Server.Installer/        # Cross-platform server installer CLI tool
├── Agent.Installer.Win/     # Windows agent installer
├── Utilities/               # PowerShell build/migration/publish scripts
└── .github/workflows/       # GitHub Actions CI/CD
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Runtime | .NET 5.0 |
| Web framework | ASP.NET Core 5, Blazor Server |
| Real-time comms | ASP.NET Core SignalR (MessagePack protocol) |
| ORM | Entity Framework Core 5 |
| Databases | SQLite (default), SQL Server, PostgreSQL |
| Windows desktop | WPF, SharpDX |
| Cross-platform desktop | Avalonia UI 0.10.6 |
| WebRTC | Microsoft.MixedReality.WebRTC 2.0.2 |
| Scripting | Microsoft PowerShell SDK 7.1.3 |
| Frontend | TypeScript (ES2017), compiled via npm/webpack |
| Testing | MSTest, Moq, EF Core InMemory |

---

## Key Architecture Concepts

### Multi-Tenancy

- The platform supports multiple **Organizations**. `MaxOrganizationCount` in `ApplicationOptions` controls how many are allowed (default: 1).
- Each organization has its own devices, users, device groups, scripts, and branding.
- Users have roles: **Server Admin**, **Organization Admin**, and **standard user**.

### Real-Time Communication (SignalR)

Three hubs in `Server/Hubs/`:

| Hub | Purpose |
|---|---|
| `AgentHub` | Persistent connection from each managed Agent to the server |
| `CasterHub` | Connection from the Desktop client (screen sender) to the server |
| `ViewerHub` | Connection from the browser (screen viewer) to the server |

SignalR uses **MessagePack** binary protocol for efficiency. Max message size is 100 KB (configured in `Startup.cs`).

### Remote Control Flow

```
Desktop Client (CasterHub) ──► Server ──► Browser (ViewerHub)
         ▲                                        │
         └────── WebRTC (peer-to-peer, Windows) ──┘
```

- On Windows, WebRTC is used for direct peer-to-peer screen streaming.
- The server relays frames when WebRTC is unavailable (Linux/macOS desktop clients).

### Agent Operation

- Each managed machine runs the **Agent** service.
- The agent connects to the server via `AgentHub` and:
  - Sends periodic heartbeats and device info updates.
  - Polls for pending script runs.
  - Accepts remote control session requests.
  - Self-updates via the `Updater` service.

### Data Layer

- EF Core with separate `DbContext` subclasses per provider:
  - `SqliteDbContext` → `Remotely.db`
  - `SqlServerDbContext`
  - `PostgreSqlDbContext`
- `DBProvider` in `ApplicationOptions` selects the active provider.
- All data access goes through `IDataService` / `DataService` (DI singleton).
- Migrations live in `Server/Data/Migrations/`.

---

## Project Conventions

### C# Style

- Use `var` for all local variables where the type is apparent or built-in (configured via `.editorconfig`).
- XML doc comments (`CS1591`) are suppressed — do not add them unless the team explicitly requests.
- Platform-compatibility analyzer (`CA1416`) is suppressed project-wide; use `[SupportedOSPlatform]` when needed for new platform-specific code.
- Dependency injection is used throughout — avoid `new`-ing services directly; register them in `Startup.cs`.

### Naming

- Models/entities: PascalCase nouns (e.g., `Device`, `RemotelyUser`, `Organization`).
- Services: interface + implementation pattern (`IDataService` / `DataService`).
- SignalR hub method names: PascalCase verbs (e.g., `SendHeartbeat`, `UpdateDevice`).
- API controllers: `{Resource}Controller` (e.g., `DevicesController`).

### Database Changes

When modifying EF Core models:

1. Edit the model in `Shared/Models/` or `Server/Data/`.
2. Run `Add-Migration.ps1` (in `Utilities/`) or use:
   ```bash
   dotnet ef migrations add <MigrationName> --project Server
   ```
3. Migrations run automatically on startup via `AppDb.MigrateAndSeed()`.

### Configuration

- `appsettings.json` — base configuration (checked into source).
- `appsettings.Production.json` — production overrides (**not** in source; created on deploy).
- All app-level settings are under the `ApplicationOptions` key and map to `ApplicationOptions.cs`.
- Never commit secrets (SMTP passwords, connection strings with credentials) to source.

### Frontend (TypeScript)

- Source lives in `Server/wwwroot/src/`.
- Compiled output goes to `Server/wwwroot/build/`.
- Build TypeScript with `npm run build` (or `npm run watch` during development) from `Server/wwwroot/`.
- The remote control viewer client is in `Server/wwwroot/src/RemoteControl/`.

---

## Build & Run

### Prerequisites

- .NET 5 SDK
- Node.js / npm (for TypeScript frontend)
- Visual Studio 2019+ or VS Code with C# extension

### Local Development

```bash
# Restore dependencies
dotnet restore

# Build TypeScript
cd Server/wwwroot
npm install
npm run build
cd ../..

# Run the server (SQLite by default)
dotnet run --project Server
```

Server runs on `https://localhost:5001` by default.

### Running Tests

```bash
dotnet test
```

Tests run from `Tests/Tests.csproj`. The test suite uses:
- MSTest as the framework
- Moq for mocking
- EF Core InMemory provider to avoid a real database

### Building Platform Clients

Because the Windows agent requires Windows and the macOS agent requires macOS, use **GitHub Actions** for full builds:

- **`/.github/workflows/build.yml`** — full multi-platform build (workflow dispatch, accepts `ServerUrl` and `ServerRid` inputs)
- **`/.github/workflows/run_tests.yml`** — runs `dotnet test` on every push/PR to `master`

To build locally for a single platform:
```bash
# Windows agent (x64)
dotnet publish Agent -r win-x64 -c Release

# macOS agent
dotnet publish Agent -r osx-x64 -c Release

# Linux agent
dotnet publish Agent -r linux-x64 -c Release
```

### Publish / Release

Use `Utilities/Publish.ps1` for packaging release artifacts.

---

## API Reference Summary

The REST API is documented at `/swagger` when the server is running.

**Authentication:** Include `[ApiToken]:[ApiSecret]` in the `Authorization` header.

Key controllers in `Server/API/`:

| Controller | Responsibility |
|---|---|
| `DevicesController` | Query/manage devices |
| `ScriptingController` | Execute scripts on devices |
| `ScriptResultsController` | Retrieve script execution results |
| `SavedScriptsController` | CRUD for saved scripts |
| `RemoteControlController` | Start remote control sessions |
| `AlertsController` | Create/manage alerts |
| `OrganizationManagementController` | Manage org users, invites, groups |
| `FileSharingController` | Upload/download shared files |
| `AgentUpdateController` | Push agent updates |
| `ClientDownloadsController` | Serve agent/client installers |

---

## Important Files

| File | Purpose |
|---|---|
| `Remotely.sln` | Visual Studio solution — entry point for building all projects |
| `Server/Startup.cs` | DI registration, middleware pipeline, SignalR config |
| `Server/Data/AppDb.cs` | Base EF Core DbContext with all entity sets |
| `Server/Services/DataService.cs` | Main data access service |
| `Server/Hubs/AgentHub.cs` | Agent ↔ Server SignalR hub |
| `Server/Hubs/CasterHub.cs` | Desktop ↔ Server SignalR hub |
| `Server/Hubs/ViewerHub.cs` | Browser ↔ Server SignalR hub |
| `Shared/Models/Device.cs` | Core device entity |
| `Shared/Models/Organization.cs` | Core organization entity |
| `Shared/Models/RemotelyUser.cs` | User entity (extends ASP.NET Identity) |
| `Agent/Services/AgentSocket.cs` | Agent's SignalR connection manager |
| `Server/appsettings.json` | Base application configuration |
| `.editorconfig` | C# code style rules |
| `Utilities/Add-Migration.ps1` | Helper for EF Core migrations |

---

## CI/CD

| Workflow | Trigger | Runner | Purpose |
|---|---|---|---|
| `run_tests.yml` | Push / PR to `master` | `windows-latest` | Run `dotnet test` |
| `build.yml` | Manual dispatch | `windows-latest` + `macos-10.15` | Full multi-platform build with code signing |

Build artifacts (agents, installers) are uploaded per-run. The `build.yml` workflow accepts:
- `ServerUrl` — embedded into agent/client binaries at compile time
- `ServerRid` — .NET runtime identifier for the server (e.g., `linux-x64`)

---

## Docker

A `Dockerfile` is provided for containerized server deployment:

- Base image: `ubuntu:focal` with .NET 5 runtime
- Data directory: `/remotely-data/` (mount as a volume)
- Default database: `/remotely-data/Remotely.db`
- Entry script: `DockerMain.sh`

```bash
docker run -d \
  -p 5000:5000 \
  -v /your/data:/remotely-data \
  translucency/remotely
```

---

## Common Tasks for AI Assistants

### Adding a new API endpoint
1. Create or extend a controller in `Server/API/`.
2. Use constructor injection for `IDataService`, `ILogger`, etc.
3. Decorate with `[Authorize]` and appropriate role policies.
4. Add Swagger annotations if exposing to external API consumers.

### Adding a new SignalR message
1. Define the method in the appropriate hub class (`AgentHub`, `CasterHub`, or `ViewerHub`).
2. Add the corresponding client-side handler in the agent (`AgentSocket.cs`) or TypeScript client.
3. If the message carries structured data, define a DTO in `Shared/Models/`.

### Adding a new database entity
1. Add the model class to `Shared/Models/`.
2. Add a `DbSet<T>` to `Server/Data/AppDb.cs`.
3. Configure relationships in `AppDb.OnModelCreating()` if needed.
4. Generate and apply a migration (see Database Changes above).

### Modifying ApplicationOptions
1. Add the property to `Server/Models/ApplicationOptions.cs`.
2. Add the corresponding entry to `appsettings.json` with a sensible default.
3. Document new options in the README under the Configuration section.

### Working with the TypeScript frontend
- The TypeScript source uses ES2017 modules.
- `ViewerHubConnection.ts` handles the SignalR connection from the browser.
- `DtoMessageHandler.ts` processes incoming binary DTO messages.
- `RtcSession.ts` manages the WebRTC peer connection.
- After changes, recompile with `npm run build` from `Server/wwwroot/`.
