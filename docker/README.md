# Running PokeMoodle in Docker

Two instances on the gemini-home VM, each its own compose project (own database, Redis, files):

| Instance | Project | Port | URL |
|---|---|---|---|
| test | `pokemoodle-test` | 8081 | https://pokemoodle-test.geminitech.co.nz |
| live | `pokemoodle` | 8082 | https://pokemoodle.geminitech.co.nz |

Caddy runs in a separate Proxmox LXC and proxies to `VM_LAN_IP:<port>` (see `instances/Caddyfile.snippet`).
Database, pgbouncer and Redis publish no ports.

## One-time setup on the VM
```bash
mkdir -p /opt/pokemoodle && cd /opt/pokemoodle
git clone --depth 1 -b main-pokemoodle https://github.com/jerryshan/moodle.git src
cp src/docker/instances/test.env.example test.env   # edit passwords + WEB_BIND (VM LAN IP)
cp src/docker/instances/prod.env.example prod.env
```
Firewall: allow ports 8081/8082 from the Caddy LXC only. Add DNS A records for both hostnames pointing at Caddy's public address, and the Caddy entries.

## Start / install the test instance
```bash
cd /opt/pokemoodle/src
dc() { docker compose --env-file ../$1.env "${@:2}"; }   # usage: dc test <args>
dc test up -d --build db redis pgbouncer
dc test run --rm web php admin/cli/install_database.php \
  --agree-license --adminuser=admin --adminpass='CHANGE_ME' --adminemail=you@example.com \
  --fullname="PokeMoodle Test" --shortname="pokemoodle-test"
dc test up -d --build
```
Repeat with `prod` for the live instance (use a different admin password). Each instance builds its own image tag (`IMAGE_TAG`), so test can run newer code than live.

## Update an instance (manual, until CD exists)
```bash
cd /opt/pokemoodle/src && git pull
dc test up -d --build
dc test exec web php admin/cli/upgrade.php --non-interactive
dc test exec web php admin/cli/purge_caches.php
```

## Where the data lives
Each instance keeps its data in plain folders under `DATA_DIR` (set in its env file), not in Docker volumes:

| Folder | Contents |
|---|---|
| `/opt/pokemoodle/<env>/pgdata` | PostgreSQL files (owned by the container's postgres user; back up with `pg_dump`, not by copying) |
| `/opt/pokemoodle/<env>/moodledata` | Uploaded files, caches, temp files |

Rebuilding or recreating containers does not touch these folders. They are only lost if the folders are deleted, or if `DATA_DIR` is changed to point somewhere else. A one-off safety dump of both databases from before the move is in `/opt/pokemoodle/backups/`.
