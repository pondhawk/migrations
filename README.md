# Pondhawk Migrations

A database schema migration CLI tool built on a vendored fork of [DbUp](https://dbup.readthedocs.io/). Provides a three-phase script execution pipeline with pre-run, main, and post-run script groups.

## Features

- **Multi-phase execution** — Scripts run in three ordered groups: pre-run (always), main (once), post-run (always)
- **RunAlways scripts** — Pre-run and post-run scripts execute on every migration, ideal for views, stored procedures, and permissions
- **RunOnce scripts** — Main migration scripts are journaled and only execute once
- **Multiple database providers** — MySQL supported out of the box, with vendored support for PostgreSQL, SQLite, and SQL Server
- **Configuration cascade** — YAML config file with CLI flag overrides
- **Validation** — Settings validated via Pondhawk.Rules before execution
- **Structured logging** — Integrated with Pondhawk.Watch for observability

## Quick Start

```bash
# Run a migration
dotnet run --project Pondhawk.One.Migrations -- Up \
  -P MySql \
  -C "server=localhost; database=mydb; user=root; password=secret;" \
  -S ./db-scripts

# Test mode (show what would run without executing)
dotnet run --project Pondhawk.One.Migrations -- Up \
  -P MySql \
  -C "server=localhost; database=mydb; user=root; password=secret;" \
  -S ./db-scripts \
  -T

# Quiet mode (no terminal output)
dotnet run --project Pondhawk.One.Migrations -- Up ... -Q
```

## Configuration

Settings can be provided via CLI flags or a `pondhawk-migrations.yml` file in the working directory. CLI flags override YAML values.

### CLI Flags

| Flag | Description |
|------|-------------|
| `-P`, `--provider` | Database provider (`MySql`) |
| `-C`, `--connection` | Connection string |
| `-S`, `--scripts-path` | Path to SQL scripts directory |
| `-Q`, `--quiet` | Suppress terminal output |
| `-T`, `--test` | Dry run — show discovered scripts without executing |

### YAML Configuration

```yaml
Provider: MySql
ConnectionString: "server=localhost; database=mydb; user=root; password=secret;"
ScriptsPath: ./db-scripts
VersionSchema: ""
VersionTable: SchemaVersions
PreRunScriptPattern: pre-run-script.sql
ScriptPattern: "script-*.sql"
PostRunScriptPattern: post-run-script.sql
```

## Script Execution Pipeline

Scripts are discovered from the filesystem and executed in three groups:

| Group | Order | Type | Pattern (default) | Description |
|-------|-------|------|-------------------|-------------|
| Pre-run | 100 | RunAlways | `pre-run-script.sql` | Runs every time, not journaled |
| Main | 1000 | RunOnce | `script-*.sql` | Runs once, journaled in version table |
| Post-run | 10000 | RunAlways | `post-run-script.sql` | Runs every time, not journaled |

Within each group, scripts are sorted by name. The `ScriptPattern` must contain a `*` wildcard.

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 100 | Configuration error |
| 200 | Database connection error |
| 300 | Upgrade execution error |

## Project Structure

```
Pondhawk.One.Migrations/          # CLI application (.NET 9.0)
Pondhawk.One.Migrations.Tests/    # xUnit test suite
dbup-core/                        # Vendored DbUp core engine
dbup-mysql/                       # MySQL provider
dbup-postgresql/                  # PostgreSQL provider
dbup-sqlite/                      # SQLite provider
dbup-sqlserver/                   # SQL Server provider
```

## Building and Testing

```bash
# Build
dotnet build pondhawk-migrations.sln

# Run tests
dotnet test Pondhawk.One.Migrations.Tests/Pondhawk.One.Migrations.Tests.csproj
```

## Why a DbUp Fork?

Stock DbUp only supports flat, run-once script execution. This fork adds:

- **`RunGroupOrder`** on `SqlScriptOptions` — enables ordered script groups
- **`ScriptType.RunAlways`** — scripts that execute every run without being journaled
- **Sorting by RunGroupOrder** in `UpgradeEngine` — pre-run before main before post-run
- **Filter bypass** for RunAlways scripts in `DefaultScriptFilter`

These changes touch DbUp's internal execution pipeline (sorting, filtering, journaling) which aren't exposed through its public extension points.

## Dependencies

- [Spectre.Console.Cli](https://spectreconsole.net/) — CLI framework and terminal UI
- [Pondhawk.Watch](https://github.com/pondhawk) — Structured logging
- [Pondhawk.Rules](https://github.com/pondhawk) — Validation engine
- [AWSSDK.RDS](https://aws.amazon.com/sdk-for-net/) — AWS RDS snapshot support

## License

Copyright (c) 2025 Pond Hawk Technologies Inc.
