# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build the solution
dotnet build fabrica-migrations.sln

# Run tests (NUnit)
dotnet test Pondhawk.One.Migrations.Tests/Pondhawk.One.Migrations.Tests.csproj

# Run a single test by name
dotnet test Pondhawk.One.Migrations.Tests/Pondhawk.One.Migrations.Tests.csproj --filter "Test1"

# Run the CLI
dotnet run --project Pondhawk.One.Migrations/Pondhawk.One.Migrations.csproj -- Up -P MySql -C "<conn>" -S ./db-scripts
```

## Architecture

This is a database schema migration CLI tool built on a vendored fork of [DbUp](https://dbup.readthedocs.io/). It uses **Spectre.Console.Cli** for the CLI framework and **Autofac** for dependency injection.

### Project Layout

- **Pondhawk.One.Migrations** — Main CLI application (.NET 9.0 console app, RootNamespace: `Pondhawk.Migrations`)
- **Pondhawk.One.Migrations.Tests** — NUnit test project
- **dbup-core** — Vendored DbUp core engine (script discovery, execution, journaling)
- **dbup-mysql / dbup-postgresql / dbup-sqlite / dbup-sqlserver** — Vendored database provider libraries

### Provider Pattern

Database support is plugged in via the `IImplementationModule` interface. Each provider (e.g., `MySqlModule`) is an Autofac `Module` that registers three components:
- `IConnectionManager` — manages database connections
- `IJournal` — tracks which scripts have been executed (via a version table)
- `IScriptExecutor` — runs SQL scripts against the database

The `CoreModule` registers the database-agnostic pieces: script providers, the upgrade listener, and builds the `UpgradeService` / `UpgradeEngine`.

New providers are wired up in `UpCommand.ExecuteAsync` via a `switch` on the `--provider` value.

### Script Execution Pipeline

Scripts are discovered from the filesystem and run in three groups:
1. **Pre-run** (RunGroupOrder 100, RunAlways) — matched by `PreRunScriptPattern`
2. **Main** (RunGroupOrder 1000, RunOnce) — matched by `ScriptPattern` (must contain `*` wildcard)
3. **Post-run** (RunGroupOrder 10000, RunAlways) — matched by `PostRunScriptPattern`

### Configuration

Settings cascade: `fabrica-one-migrations.yml` file → CLI flags (`-P`, `-C`, `-S`, `-Q`, `-T`). CLI flags override YAML. Validation uses `Pondhawk.Rules` (`SettingsValidationBuilder`).

### Exit Codes

- `0` — Success
- `100` — Configuration error
- `200` — Database connection error
- `300` — Upgrade execution error

## Key Dependencies

- **Pondhawk.Watch** — Logging framework (used throughout via `this.EnterMethod()`)
- **Pondhawk.Rules** — Validation rule engine
- **Pondhawk.Utilities.Container** — Autofac extensions (`BuildAndStart`)
- **Spectre.Console / Spectre.Console.Cli** — CLI framework and UI rendering
- **AWSSDK.RDS** — AWS RDS integration (for snapshot support)
