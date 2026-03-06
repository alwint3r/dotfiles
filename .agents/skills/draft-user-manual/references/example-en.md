# LRS Collector Deployment User Manual (Windows amd64)

This manual describes how to deploy and operate LRS Collector using a prepared Windows deployment package. It is written for operators and system administrators. All instructions below use deployment artifacts only.

## 1. Deployment Model and Scope

This chapter explains how the deployment should run in production so operators can confirm the deployment setup before making changes. The setup is intentionally simple: one deployment root, two services, one shared runtime configuration file, and one selected database backend. Understanding this setup first reduces most startup and troubleshooting mistakes later in the process.

A standard deployment uses this structure:

- `<deploy-root>\collector` (service wrappers, scripts, config, migrations)
- `<deploy-root>\pgsql` (PostgreSQL binaries including `bin`)

From `<deploy-root>\collector`, it runs two Windows services:

- `lrscollector-server` (wrapper: `lrscollector-server.exe`, runtime: `server.exe`)
- `lrscollector-worker` (wrapper: `lrscollector-worker.exe`, runtime: `worker.exe`)

Both services use the same `config.json` and the same working directory (`<deploy-root>\collector`).

Default deployment database: PostgreSQL.

Alternative deployment database: SQLite (use only with the limitations in Section 11).

## 2. Deployment Package Inventory

This chapter ensures the package is complete before you begin service registration or database setup. Missing files are one of the most common causes of deployment failure, especially when packages are copied between systems manually. A full artifact inventory check at the start prevents partial installs and hard-to-diagnose runtime errors.

Copy the deployment package to a permanent folder, for example `C:\lrscollector`.

Before continuing, confirm these artifacts exist.

In `C:\lrscollector\collector`:

| Item Name | Notes |
|---|---|
| `server.exe` | Main API service runtime process. WinSW launches this executable through `lrscollector-server.exe`. |
| `worker.exe` | Background synchronization and scheduled-job runtime process. WinSW launches this executable through `lrscollector-worker.exe`. |
| `xtask.exe` | Deployment helper CLI used for database migrations and config-related tasks. Keep this file available for upgrade and troubleshooting operations. |
| `lrscollector-server.exe` | WinSW wrapper executable for the server service. It handles install/start/stop lifecycle integration with Windows Service Control Manager. |
| `lrscollector-worker.exe` | WinSW wrapper executable for the worker service. It ensures consistent service restart and lifecycle behavior for `worker.exe`. |
| `lrscollector-server.xml` | WinSW service definition file for the server wrapper. It controls command, logging, and restart policy configuration. |
| `lrscollector-worker.xml` | WinSW service definition file for the worker wrapper. It controls command, logging, and restart policy configuration. |
| `install-services.ps1` | Installs or reinstalls both WinSW services in one step. Run this in elevated PowerShell during first deployment or service repair. |
| `start-services.ps1` | Starts both collector services. Use this after install, restart windows, or maintenance windows. |
| `stop-services.ps1` | Stops both collector services cleanly. Use this before upgrades, rollback, or maintenance changes. |
| `restart-services.ps1` | Restarts both services in one command. Use this after config updates or minor operational changes. |
| `status-services.ps1` | Displays current service status for server and worker. Use this as the first quick health check after lifecycle operations. |
| `uninstall-services.ps1` | Uninstalls both WinSW services from Windows Service Control Manager. Use this for clean removal or full service re-provisioning. |
| `register-postgres-service.ps1` | Initializes PostgreSQL data directory when needed and registers/starts the PostgreSQL Windows service. It requires `-PgBinDir` and `-DataDir`. |
| `setup-postgres.ps1` | Creates or updates deployment database credentials and applies required privileges. Use this before running PostgreSQL migrations. |
| `unregister-postgres-service.ps1` | Stops and unregisters the PostgreSQL Windows service without deleting data files. Use this for service teardown while preserving database files. |
| `config.json` | Single runtime configuration file shared by server and worker. Validate DB backend, DSN, and API credentials before first start. |
| `migrations\` (directory) | SQL migration scripts consumed by `xtask.exe migrate`. Keep this directory intact to support fresh installs and upgrades. |

In `C:\lrscollector\pgsql`:

| Item Name | Notes |
|---|---|
| `bin\` (directory) | PostgreSQL executable directory referenced by deployment scripts through `-PgBinDir`. Do not move this folder unless you also update script arguments. |
| `bin\pg_ctl.exe` | PostgreSQL control utility used to register, unregister, and manage the database service process. `register-postgres-service.ps1` depends on this binary. |
| `bin\initdb.exe` | PostgreSQL cluster initialization utility used on first-time setup. It creates the data directory structure and initial system catalog. |
| `bin\psql.exe` | PostgreSQL command-line client used for provisioning, grants, and manual SQL checks. `setup-postgres.ps1` depends on this binary. |

Verification command:

```powershell
Get-ChildItem C:\lrscollector\collector
Get-ChildItem C:\lrscollector\pgsql\bin
```

## 3. Host Requirements

This chapter lists the baseline operating conditions required for stable operation. Meeting these requirements in advance avoids interruptions during installation and avoids permissions failures that otherwise appear later as service startup errors. Treat these requirements as mandatory for first-time deployment and for every new host.

Target host requirements:

- Windows amd64
- Administrator access for service install/start/stop/restart/uninstall scripts
- Local write permission in `collector` deployment folder for:
  - logs
  - firmware files
  - SQLite file (if SQLite is used)

PostgreSQL deployment requirements:

- Bundled PostgreSQL binaries in deployment package:
  - `<deploy-root>\pgsql\bin\pg_ctl.exe`
  - `<deploy-root>\pgsql\bin\initdb.exe`
  - `<deploy-root>\pgsql\bin\psql.exe`

## 4. Pre-Deployment Checks

This chapter provides a fast preflight sequence to validate the machine state before any write or install action is performed. Running these checks in order confirms that the working directory, scripts, executables, migrations, and service port are ready. Completing preflight first significantly reduces rollback and rework during the install phase.

On Windows 11, open an elevated PowerShell by clicking Start (or pressing the Windows key), typing `PowerShell`, then choosing **Run as administrator** on **Windows PowerShell** (or **PowerShell**). When User Account Control asks for permission, click **Yes**. Before running the commands below, confirm you are in the Administrator session you just opened.

From an elevated PowerShell window:

1. Go to collector deployment folder:

```powershell
Set-Location C:\lrscollector\collector
```

2. Confirm scripts are present:

```powershell
Get-ChildItem *.ps1
```

3. Confirm wrapper and runtime executables are present:

```powershell
Get-ChildItem *.exe
```

4. Confirm migration files are present:

```powershell
Get-ChildItem .\migrations
```

5. Confirm bundled PostgreSQL binaries are present:

```powershell
Get-ChildItem ..\pgsql\bin\pg_ctl.exe,..\pgsql\bin\initdb.exe,..\pgsql\bin\psql.exe
```

6. Confirm port `1323` is available (default HTTP port):

```powershell
Get-NetTCPConnection -LocalPort 1323 -ErrorAction SilentlyContinue
```

Expected result: no listening process using that port before first start.

## 5. Configure `config.json`

This chapter covers the single most important runtime control file in the `collector` deployment folder. Correct configuration values determine network binding, backend database connectivity, and worker behavior from the moment services start. Finalize these settings before installation so first startup uses intended production values.

Edit `config.json` in the `collector` deployment folder before first startup.

At minimum, verify these areas:

- `db.backend` and database connection values (`db.postgres.*` for default deployment)
- `server.address` and core runtime values (`server.request_timeout`, `server.shutdown_timeout`)
- `worker.api` credentials and scheduler values (`worker.scheduler.*`)
- outbox retry policy (`worker.outbox.*` and top-level `outbox.max_attempt_count`)

### 5.1 Database

Set the database backend first, then complete the matching database section. For standard deployment, use PostgreSQL by setting `db.backend` to `postgres`.

For PostgreSQL, `db.postgres.dsn` is required. Keep connection pool values positive, and keep lifetime values at `0` or higher.

```json
"db": {
  "backend": "postgres",
  "postgres": {
    "dsn": "postgres://lrscollector:<password>@localhost:5432/lrscollector?sslmode=disable",
    "max_open_conns": 10,
    "max_idle_conns": 5,
    "conn_max_lifetime": "1h",
    "conn_max_idle_time": "30m"
  }
}
```

If you choose SQLite instead, set `db.backend` to `sqlite` and provide `db.path` plus valid `db.sqlite.*` values.

### 5.2 Server

The server section controls listener binding and request handling behavior. Set `server.address` to the intended bind address (default `:1323`), then validate runtime limits and health metadata.

- `server.request_timeout` must be greater than `0`
- `server.shutdown_timeout` must be greater than `0`
- `server.body_limit_bytes` must be greater than `0`
- `server.health.service` must be non-empty
- `server.health.api_version` must be greater than `0`

```json
"server": {
  "address": ":1323",
  "request_timeout": "10s",
  "shutdown_timeout": "5s",
  "body_limit_bytes": 1048576,
  "health": {
    "service": "lrscollector-server",
    "api_version": 1
  }
}
```

### 5.3 Worker

`worker.api` defines outbound authentication and endpoint settings used by the sync worker. Ensure all API credentials are set before service startup.

`worker.scheduler` controls when and how often synchronization jobs run. Keep `enabled` set to `true` for service mode. If `worker.scheduler.enabled` is set to `false`, `worker.exe` exits quickly and the service wrapper will repeatedly attempt restart.

Choose a valid IANA timezone (for example `Asia/Jakarta`), set `cron` to the required schedule, and use `run_on_startup` if you want an immediate sync attempt at service startup. Keep `job_timeout_seconds` and `shutdown_timeout_seconds` at least `1`.

```json
"worker": {
  "api": {
    "base_url": "https://example.com",
    "static_username": "<static-user>",
    "static_password": "<static-pass>",
    "auth_username": "<auth-user>",
    "auth_password": "<auth-pass>",
    "token_ttl_minutes": 55
  },
  "scheduler": {
    "enabled": true,
    "timezone": "Asia/Jakarta",
    "cron": "*/5 * * * *",
    "run_on_startup": true,
    "job_timeout_seconds": 30,
    "shutdown_timeout_seconds": 5
  }
}
```

### 5.4 Outbox

Outbox behavior is controlled in two places and should be tuned together:

- `worker.outbox.*` controls fetch size and retry delay timing
- top-level `outbox.max_attempt_count` controls retry attempt budget

`worker.outbox.fetch_limit` must be at least `1`. `worker.outbox.retry_base_delay_seconds` and `worker.outbox.retry_max_delay_seconds` must be at least `1`, and `retry_max_delay_seconds` must be greater than or equal to `retry_base_delay_seconds`.

`outbox.max_attempt_count` must be at least `1`. Increase it for unstable links that need more retries; reduce it for faster failure surfacing.

```json
"worker": {
  "outbox": {
    "fetch_limit": 10,
    "retry_base_delay_seconds": 60,
    "retry_max_delay_seconds": 3600
  }
},
"outbox": {
  "max_attempt_count": 10
}
```

## 6. Default Database Path: PostgreSQL

This chapter is the primary deployment path and should be treated as the standard production setup. PostgreSQL provides server-grade database behavior with stronger operational patterns for concurrent workloads and long-running environments. Follow this chapter unless you explicitly choose the constrained SQLite alternative in Section 11.

This is the recommended and default production path.

### 6.1 Register and start PostgreSQL Windows service

Run in elevated PowerShell:

```powershell
.\register-postgres-service.ps1 `
  -PgBinDir "..\pgsql\bin" `
  -DataDir  ".\postgres-data" `
  -SuperuserName "postgres" `
  -SuperuserPassword (Read-Host -AsSecureString "PostgreSQL superuser password")
```

What this does:

- Initializes the PostgreSQL data directory when needed
- Registers Windows service `postgresql-lrscollector` by default
- Starts the PostgreSQL service

### 6.2 Provision deployment database and user

Run in elevated PowerShell:

```powershell
.\setup-postgres.ps1 `
  -PgBinDir          "..\pgsql\bin" `
  -SuperuserPassword (Read-Host -AsSecureString "Superuser password") `
  -DbUser            lrscollector `
  -DbPassword        (Read-Host -AsSecureString "Deployment DB password")
```

Expected outcome:

- Database user is created or updated
- Database is created if missing
- Privileges are granted
- Script prints a DSN in this format:

```text
postgres://<DbUser>:<password>@<Host>:<Port>/<DbName>?sslmode=disable
```

Copy this DSN into `config.json` at `db.postgres.dsn`.

### 6.3 Run database migrations (PostgreSQL)

Run in `collector` deployment folder:

```powershell
.\xtask.exe migrate up --db "postgres://lrscollector:<password>@localhost:5432/lrscollector?sslmode=disable" --db-type postgres
```

Expected outcome:

- Migration runner completes without error
- Database schema is ready for service startup

Optional version check:

```powershell
.\xtask.exe migrate version --db "postgres://lrscollector:<password>@localhost:5432/lrscollector?sslmode=disable" --db-type postgres
```

## 7. Install and Start LRS Collector Services

This chapter transitions from preparation into active service operation. The installation script prepares required writable directories, applies service account permissions, and registers both wrappers so they can be controlled consistently. After install, service startup and status checks confirm readiness for traffic.

### 7.1 Install services

Run in elevated PowerShell:

```powershell
.\install-services.ps1
```

What this does:

- Creates `logs\server`, `logs\worker`, and `fw_bin`
- Grants `LocalService` write permission in the `collector` deployment folder
- Installs or reinstalls both services

### 7.2 Start services

Run in elevated PowerShell:

```powershell
.\start-services.ps1
```

### 7.3 Check service status

Run in PowerShell:

```powershell
.\status-services.ps1
```

Expected status: both services show `Running`.

## 8. Post-Deployment Verification

This chapter verifies that deployment is not only installed but operational. Health checks confirm API reachability, OTA page checks confirm admin UI availability, and log inspection confirms startup quality and early runtime behavior. Complete all checks before handing over the system as production-ready.

### 8.1 Health endpoint

Run:

```powershell
(Invoke-WebRequest http://localhost:1323/health).Content | ConvertFrom-Json
```

Expected response shape:

```json
{
  "service": "lrs-collector",
  "api_ver": 1
}
```

### 8.2 OTA admin page

Open in browser:

- `http://localhost:1323/ota/admin`

Expected result: OTA admin page loads.

### 8.3 Logs

Check wrapper logs for startup errors:

```powershell
Get-ChildItem .\logs\server
Get-ChildItem .\logs\worker
```

## 9. Day-2 Operations

This chapter defines routine service lifecycle commands for normal operations after go-live. Keeping these commands in one place helps operators perform controlled maintenance, restarts, and uninstall actions without improvising command sequences. Always execute these actions from the `collector` deployment folder to preserve expected wrapper behavior.

Commands below run from `collector` deployment folder.

Start services (elevated):

```powershell
.\start-services.ps1
```

Stop services (elevated):

```powershell
.\stop-services.ps1
```

Restart services (elevated):

```powershell
.\restart-services.ps1
```

Show status:

```powershell
.\status-services.ps1
```

Uninstall services (elevated):

```powershell
.\uninstall-services.ps1
```

## 10. Upgrade Procedure

This chapter describes a safe in-place upgrade workflow that protects runtime state and minimizes downtime. The sequence is designed to preserve configuration and data, apply schema updates in the correct order, and return both services to healthy operation with explicit verification. Do not skip backup or migration steps during upgrades.

Run this sequence in order:

1. Stop services:

```powershell
.\stop-services.ps1
```

2. Back up current runtime state:

- `config.json`
- database data (`lrs-collector.db` if SQLite is used)
- `logs\`
- `fw_bin\`

3. Replace package artifacts with the new release artifacts under the same root:

- `<deploy-root>\collector\*`
- `<deploy-root>\pgsql\*`

4. Re-check `config.json` values, especially:

- `db.backend`
- `db.postgres.dsn`
- `worker.api`

5. Run migrations for your active backend.

PostgreSQL:

```powershell
.\xtask.exe migrate up --db "postgres://lrscollector:<password>@localhost:5432/lrscollector?sslmode=disable" --db-type postgres
```

SQLite:

```powershell
.\xtask.exe migrate up --db lrs-collector.db
```

6. Start services:

```powershell
.\start-services.ps1
```

7. Re-run health and status checks.

## 11. Alternative Database Path: SQLite (Warning)

This chapter documents SQLite as an exception path, not the default. SQLite can be useful for constrained single-host cases, but it is an in-process storage model with operational and scaling tradeoffs compared to a server RDBMS. Read this section completely before choosing SQLite so the decision is deliberate and risk-aware.

Warning: SQLite is an in-process database engine, not a separate database server. Use SQLite only for constrained single-host scenarios, pilot environments, or low-concurrency edge cases.

Key limitations compared with PostgreSQL:

- Concurrency limitations: write-heavy multi-client workloads are more constrained.
- Topology limitations: no independent database server process for remote administration patterns.
- Availability limitations: no built-in server-grade failover or replication model.
- Operational limitations: backup and maintenance windows are more sensitive to active file access.

For production environments requiring stronger multi-user concurrency, operational resilience, and scalable RDBMS behavior, use PostgreSQL.

### 11.1 Configure SQLite mode

In `config.json`:

```json
"db": {
  "backend": "sqlite",
  "path": "lrs-collector.db"
}
```

### 11.2 Run SQLite migrations

```powershell
.\xtask.exe migrate up --db lrs-collector.db
```

### 11.3 Service startup in SQLite mode

Service install/start commands are the same as PostgreSQL mode.

Important: ensure `collector` deployment folder remains writable so `lrs-collector.db` and WAL files can be created and updated.

## 12. Rollback Procedure

This chapter provides a controlled recovery path for failed or unstable deployments. The objective is to restore a known-good runtime state quickly while protecting database integrity and service consistency. Execute rollback in sequence and always re-run health validation before returning the system to users.

Use rollback when a deployment fails verification.

1. Stop services:

```powershell
.\stop-services.ps1
```

2. Restore previous known-good artifacts:

- runtime executables
- wrapper executables and XML files
- scripts
- `config.json`

3. Restore database state if required:

- PostgreSQL: restore from database backup or snapshot policy.
- SQLite: restore backed up `lrs-collector.db` and related WAL/SHM files.

4. Start services:

```powershell
.\start-services.ps1
```

5. Validate status and health endpoint.

## 13. Troubleshooting

This chapter offers symptom-based diagnostics so operators can quickly map failures to likely causes and corrective actions. Start with the matching symptom, apply checks in order, and re-test after each corrective step. This approach shortens outage duration and avoids unnecessary broad changes.

### Symptom: `install-services.ps1` fails with privilege error

Cause:

- PowerShell not elevated.

Action:

- Reopen PowerShell as Administrator and run again.

### Symptom: status shows service not installed

Cause:

- Install step not executed or failed.

Action:

- Run `install-services.ps1`, then `start-services.ps1`.

### Symptom: health endpoint not reachable

Cause candidates:

- Service not running
- Port conflict
- Invalid `config.json`

Actions:

1. Run `status-services.ps1`.
2. Check logs in `logs\server`.
3. Verify `server.address` and database configuration.

### Symptom: PostgreSQL migration fails

Cause candidates:

- DSN invalid
- PostgreSQL service not running
- Insufficient database privileges

Actions:

1. Verify PostgreSQL service is running.
2. Re-run `setup-postgres.ps1` to ensure user/password/privileges.
3. Re-run migration command with corrected DSN.

### Symptom: worker keeps restarting

Cause candidate:

- `worker.scheduler.enabled` set to `false`.

Action:

- Set `worker.scheduler.enabled` to `true` in `config.json` and restart services.

## 14. Command Reference

This chapter is a quick-lookup index for frequent operational commands. Use it during incidents or maintenance windows when speed matters and you need exact command syntax without searching across earlier sections. Commands here assume you are already in the `collector` deployment folder.

Install services (elevated):

```powershell
.\install-services.ps1
```

Start services (elevated):

```powershell
.\start-services.ps1
```

Stop services (elevated):

```powershell
.\stop-services.ps1
```

Restart services (elevated):

```powershell
.\restart-services.ps1
```

Status:

```powershell
.\status-services.ps1
```

Uninstall services (elevated):

```powershell
.\uninstall-services.ps1
```

Register PostgreSQL service (elevated):

```powershell
.\register-postgres-service.ps1 -PgBinDir "..\pgsql\bin" -DataDir ".\postgres-data" -SuperuserPassword (Read-Host -AsSecureString)
```

Setup PostgreSQL database/user:

```powershell
.\setup-postgres.ps1 -PgBinDir "..\pgsql\bin" -SuperuserPassword (Read-Host -AsSecureString) -DbUser lrscollector -DbPassword (Read-Host -AsSecureString)
```

Run PostgreSQL migrations:

```powershell
.\xtask.exe migrate up --db "postgres://..." --db-type postgres
```

Run SQLite migrations:

```powershell
.\xtask.exe migrate up --db lrs-collector.db
```

Health check:

```powershell
(Invoke-WebRequest http://localhost:1323/health).Content | ConvertFrom-Json
```
