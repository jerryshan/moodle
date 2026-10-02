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
mkdir -p ~/pokemoodle && cd ~/pokemoodle
git clone --depth 1 -b main-pokemoodle https://github.com/jerryshan/moodle.git src
cp src/docker/instances/test.env.example test.env   # edit passwords + WEB_BIND (VM LAN IP)
cp src/docker/instances/prod.env.example prod.env
```
Firewall: allow ports 8081/8082 from the Caddy LXC only. Add DNS A records for both hostnames pointing at Caddy's public address, and the Caddy entries.

## Start / install the test instance
```bash
cd ~/pokemoodle/src
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
cd ~/pokemoodle/src && git pull
dc test up -d --build
dc test exec web php admin/cli/upgrade.php --non-interactive
dc test exec web php admin/cli/purge_caches.php
```
