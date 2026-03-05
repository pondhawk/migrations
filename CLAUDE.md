# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build the solution
dotnet build pondhawk-migrations.sln

# Run tests (xUnit)
dotnet test tests/Pondhawk.Migrations.Tests/Pondhawk.Migrations.Tests.csproj

# Run a single test by name
dotnet test tests/Pondhawk.Migrations.Tests/Pondhawk.Migrations.Tests.csproj --filter "Should_sort_scripts_by_run_group_order_then_name"

# Run the CLI
dotnet run --project src/Pondhawk.Migrations/Pondhawk.Migrations.csproj -- Up -P MySql -C "<conn>" -S ./db-scripts

# Pack as dotnet tool
dotnet pack src/Pondhawk.Migrations/Pondhawk.Migrations.csproj -c Release -o ./nupkg
```

## Architecture

This is a database schema migration CLI tool built on a vendored fork of [DbUp](https://dbup.readthedocs.io/). It uses **Spectre.Console.Cli** for the CLI framework and **Microsoft.Extensions.DependencyInjection** for DI. It is packaged as a **dotnet tool** (`pondhawk-migrations`).

### Project Layout

```
src/
  Pondhawk.Migrations/        — Main CLI application (.NET 9.0, RootNamespace: Pondhawk.Migrations)
  dbup-core/                      — Vendored DbUp core engine (script discovery, execution, journaling)
  dbup-mysql/                     — MySQL provider
  dbup-postgresql/                — PostgreSQL provider
  dbup-sqlite/                    — SQLite provider
  dbup-sqlserver/                 — SQL Server provider
tests/
  Pondhawk.Migrations.Tests/  — xUnit test project (NSubstitute, Shouldly)
build/                            — Cake Frosting build project (future)
```

### Provider Pattern

Database support is plugged in via the `IImplementationModule` interface. Each provider (e.g., `MySqlModule`) registers three components:
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

Settings cascade: `pondhawk-migrations.yml` file → CLI flags (`-P`, `-C`, `-S`, `-Q`, `-T`). CLI flags override YAML. Validation uses `Pondhawk.Rules` (`SettingsValidationBuilder`).

### Exit Codes

- `0` — Success
- `100` — Configuration error
- `200` — Database connection error
- `300` — Upgrade execution error

## Key Dependencies

- **Serilog + Serilog.Sinks.Console** — Structured logging (warnings and above)
- **Pondhawk.Rules** — Validation rule engine
- **Spectre.Console / Spectre.Console.Cli** — CLI framework and UI rendering
- **AWSSDK.RDS** — AWS RDS integration (for snapshot support)
