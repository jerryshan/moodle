# TASKS

Rules for this file and the roadmap page:
- Roadmap numbers (T-xxx) and decision numbers (D-xx) are fixed. Never reuse or renumber; new items take the next free number.
- Entries below use their own section numbers (1.1, 1.2 ...). Roadmap cards point at them, e.g. "1.1-1.5".
- Every change requested is recorded here and on the roadmap page, even if finished straight away.
- New features go behind a switch and stay "ready for your test" until the owner says they can go live.
- Last updated: 2026-10-02.

## Roadmap numbers

Three streams: **Platform** (hosting, delivery, operations: T-001 to T-010, T-013, T-014), **AI workflow** (the ai-playbook project and how projects use it: T-011, T-012, T-015, T-016) and **Product** (what PokeMoodle does: T-017 onward; vision in PRODUCT.md).

| Roadmap | Priority | Horizon | Title | Entries in this file |
|---|---|---|---|---|
| T-017 | High   | Done  | Define the PokeMoodle product roadmap (Product stream) | 11.1-11.3 |
| T-018 | High   | Next  | Plan the plugins (Product) | 13.1-13.3 |
| T-019 | High   | Now   | Design the game rules (Product focus) | 12.1-12.3 |
| T-020 | High   | Next  | The Pokémon look and feel (Product) | 14.1-14.4 |
| T-021 | High   | Next  | Trainer profile and collection (Product) | 15.1-15.4 |
| T-022 | High   | Next  | Battle activity (Product) | 16.1-16.5 |
| T-023 | Medium | Later | Gym badges and the Elite Four (Product) | 18.1-18.3 |
| T-024 | Medium | Later | Pokédex and trainer card (Product) | 19.1-19.2 |
| T-025 | Medium | Later | Items and the Pokémon Center (Product) | 20.1-20.3 |
| T-026 | Medium | Later | Class battles and leaderboards (Product) | 21.1-21.3 |
| T-027 | Medium | Later | Teacher kit (Product) | 22.1-22.3 |
| T-028 | High   | Next  | Quality checks for our plugins (Product) | 17.1-17.3 |
| T-029 | Medium | Next  | Keep the artwork separate (Product) | 12.4-12.5 |
| T-030 | Low    | Later | Mobile app, sound and animation (Product) | 23.1-23.3 |
| T-014 | High   | Now   | Move to the latest Moodle (upstream main, now 5.3 RC) | 10.1-10.4 |
| T-001 | High   | Now   | Package the site so it runs the same everywhere | 1.1-1.5 |
| T-002 | High   | Now   | Run it on your own computer (current focus)     | 2.1-2.4 |
| T-003 | High   | Next  | Test site at pokemoodle-test                    | 3.1-3.4 |
| T-004 | High   | Now   | Automatic checks on every change                | 4.1-4.4 |
| T-005 | High   | Next  | Keep up with Moodle upstream main (every 2 weeks) | 5.1-5.4 |
| T-006 | High   | Next  | Automatic update of the test site               | 6.1-6.4 |
| T-007 | Medium | Next  | Live site at pokemoodle, with approval          | 7.1-7.4 |
| T-008 | High   | Later | Nightly backups and a tested restore            | 8.1-8.3 |
| T-009 | Low    | Later | Use Redis for Moodle's own caches               | 8.7-8.8 |
| T-010 | Medium | Later | Health checks and alerts                        | 8.4-8.6 |
| T-011 | Medium | Next  | Shared AI playbook project                      | 9.1-9.3 |
| T-012 | Low    | Later | Project instructions for AI helpers             | 9.4-9.5 |
| T-013 | Low    | Later | Copy live data to the test site, anonymised     | 8.9-8.10 |
| T-015 | Medium | Later | Moodle playbook for AI helpers                  | 9.6-9.7 |
| T-016 | Medium | Later | Moodle CI/CD playbook for AI helpers            | 9.8-9.9 |

## Decisions

| Decision | Waiting on you |
|---|---|
| D-08 Where should the artwork live? | Optional: keep Pokémon pictures, sounds and fonts in a private place, code in the public repo. Unblocks T-029. |
| D-09 Approve the first playable slice | Approve: one themed course, a trainer card and one battle on the test site. Unblocks T-018. |
| D-01 Can GitHub reach your server? | Set up: confirm whether gemini-home accepts SSH from the internet, or use a runner on the server. Unblocks T-006. |

## 10. Latest Moodle (T-014)
- [x] 10.1 Fetch upstream main and fast-forward this copy onto it (done locally 2026-10-02, now 5.3 RC2; not pushed)
- [x] 10.2 Adapt the Docker image to the new layout (web root is now the public folder, new routing rule for Apache)
- [x] 10.3 Check PHP version and extensions needed by the new version (PHP 8.3+, added sodium)
- [x] 10.4 Fresh install works (done on the test server, Moodle 5.3 RC2, PostgreSQL 17)

## 1. Package the site (T-001)
- [x] 1.1 Dockerfile with base, dev and prod targets
- [x] 1.2 docker-compose stack: Apache, PostgreSQL, pgbouncer, Redis, cron
- [x] 1.3 Environment-driven Moodle config
- [x] 1.4 Example env file and ignore file
- [x] 1.5 First real build and install; confirm pgbouncer works (done on test: install ran through pgbouncer in transaction mode)

## 2. Run it locally (T-002)
- [ ] 2.1 Dev compose file: code mounted, direct database, cron off
- [ ] 2.2 Mail catcher for test emails
- [ ] 2.3 PHPUnit workflow (install dev tools, init, run a component)
- [ ] 2.4 Day-to-day commands written down

## 3. Test site (T-003)
- [x] 3.1 Second compose project (own ports, database, volumes): env examples + docker/README.md written
- [x] 3.2 Caddy site block for pokemoodle-test.geminitech.co.nz pointing at the container's non-conflicting host port (D-02 decided: Caddy handles HTTPS)
- [x] 3.3 Environment file on the server (/opt/pokemoodle/test.env on gemini-home; admin password changed by you, no copy kept)
- [x] 3.4 First install and smoke test (http://192.168.1.156:8081 returns the login page; sessions in Redis; cron running). Caddy entry and DNS applied by you; test.env switched to https (sslproxy on, reverseproxy off because Caddy passes the Host header).

## 4. Automatic checks (T-004)
- [ ] 4.1 PHP syntax check on changed files
- [ ] 4.2 Build the image
- [ ] 4.3 Install from scratch through pgbouncer and load the login page
- [x] 4.4 Review Moodle's inherited workflows and turn off the heavy ones (push.yml now manual only; others were already manual)

## 5. Upstream updates (T-005)
- [x] 5.1 Add upstream remote
- [ ] 5.2 Sync script (main: fetch upstream + ff-only; then merge main into main-pokemoodle) with a "how far behind" check
- [ ] 5.3 Job every 2 weeks that opens a merge request
- [ ] 5.4 Token so the merge request can run checks and touch workflow files

## 6. Deploy to test (T-006)
- [ ] 6.1 Publish built image to a registry
- [ ] 6.2 Deploy script: maintenance on, update, upgrade, purge caches, maintenance off
- [ ] 6.3 Deploy job after checks pass on main
- [ ] 6.4 Secrets for server access

## 7. Live site (T-007)
- [x] 7.1 Live stack and environment file (running at https://pokemoodle.geminitech.co.nz, port 8082, /opt/pokemoodle/prod.env; admin password must be set by you with reset_password.php)
- [ ] 7.2 Approval step before deploying (D-05 decided: only you approve)
- [ ] 7.3 Promote the same image that passed on test
- [ ] 7.4 Rollback procedure

## 8. Operations (T-008, T-010, T-009, T-013)
- [ ] 8.1 Nightly database dump and file backup (data now in plain folders under /opt/pokemoodle; first one-off dumps exist)
- [ ] 8.2 Off-server copy
- [ ] 8.3 Tested restore
- [ ] 8.4 Site up check
- [ ] 8.5 Cron last-run check
- [ ] 8.6 Alerts, log rotation, container limits
- [ ] 8.7 Redis as Moodle cache store
- [ ] 8.8 Verify cache hit rates
- [ ] 8.9 Anonymised copy of live data to test
- [ ] 8.10 On-demand refresh command

## 9. AI playbook (T-011, T-012)
- [x] 9.1 Create ai-playbook repo and add to session (D-04, done)
- [x] 9.2 Scaffold layout: playbooks, templates, adapters, scripts
- [ ] 9.3 Move generic deploy and sync procedures into it (roadmap-page procedure already added)
- [ ] 9.4 AGENTS.md for this project
- [ ] 9.5 CLAUDE.md that imports AGENTS.md

- [ ] 9.6 Moodle playbook: layout (public folder), CLI scripts, upgrade steps, coding rules, plugin checks
- [ ] 9.7 Claude/OpenAI adapters for it
- [ ] 9.8 Moodle CI/CD playbook: build, install smoke test, maintenance-mode deploy, upgrade, rollback
- [ ] 9.9 Adapters for it (write both after the pipeline has really run once)

## 11. Product roadmap (T-017)
- [x] 11.1 Capture goals, audience, features, theme and plugins from the owner (D-07 answered)
- [x] 11.2 Turn each idea into a Product card with priority and horizon (T-018 to T-030)
- [ ] 11.3 Decide which changes need feature switches and which go on the test site first

## 12. Game rules and artwork (T-019, T-029)
- [ ] 12.1 Battle model: quiz question as a move, hits, HP, turns, win and lose
- [ ] 12.2 Progression: points, levels, catching the 151, evolution
- [ ] 12.3 Fairness and integrity: no grade impact unless a teacher chooses it
- [ ] 12.4 Private artwork store (D-08)
- [ ] 12.5 Load artwork into the theme at deploy time, not from the public repo

## 13. Plugin plan (T-018)
- [ ] 13.1 List of plugins and their jobs (theme, local engine, battle activity, blocks)
- [ ] 13.2 Where they live in this repo (under public/, new folders only) and naming
- [ ] 13.3 Rule for any core change: recorded and justified in PRODUCT.md

## 14. Look and feel (T-020)
- [ ] 14.1 Theme plugin, child of Boost
- [ ] 14.2 Colours, pixel font, login page
- [ ] 14.3 Dashboard and course pages
- [ ] 14.4 Reduced-motion and contrast checks

## 15. Trainer and collection (T-021)
- [ ] 15.1 Engine plugin: trainer, points, level, party, collection
- [ ] 15.2 Award rules from Moodle events (completion, quiz attempts)
- [ ] 15.3 Privacy provider
- [ ] 15.4 Site and course switches

## 16. Battle activity (T-022)
- [ ] 16.1 Activity plugin skeleton
- [ ] 16.2 Questions from the question bank
- [ ] 16.3 Turn-based battle screen
- [ ] 16.4 Results: points, catches, completion
- [ ] 16.5 Gradebook only if the teacher turns it on

## 17. Plugin quality (T-028)
- [ ] 17.1 moodle-plugin-ci in the pipeline (code style, PHPDoc, Mustache, JS)
- [ ] 17.2 PHPUnit and Behat tests for each plugin
- [ ] 17.3 Accessibility checks

## 18. Badges and Elite Four (T-023)
- [ ] 18.1 Regions mapped to courses
- [ ] 18.2 Gym badges using Moodle badges
- [ ] 18.3 Final challenge

## 19. Dashboard blocks (T-024)
- [ ] 19.1 Pokédex block
- [ ] 19.2 Trainer card block

## 20. Items and Pokémon Center (T-025)
- [ ] 20.1 Items and hints
- [ ] 20.2 Revision mode
- [ ] 20.3 Day and night theme

## 21. Class battles (T-026)
- [ ] 21.1 Head-to-head battles
- [ ] 21.2 Leaderboards with opt-out
- [ ] 21.3 Teacher view

## 22. Teacher kit (T-027)
- [ ] 22.1 Demo course
- [ ] 22.2 Question templates
- [ ] 22.3 Teacher guide

## 23. Mobile and media (T-030)
- [ ] 23.1 Mobile app support
- [ ] 23.2 Optional sound
- [ ] 23.3 Animation polish

## Done
- T-017 / D-07: product idea captured in PRODUCT.md (gamified Moodle, original 151 Pokémon, Gold/Silver-style turn-based battles, new plugins with core left alone). Product cards T-018 to T-030 and decisions D-08 (artwork location, optional) and D-09 (first playable slice) added.
- Added a third stream, AI workflow (the ai-playbook project): T-011, T-012, T-015, T-016. Filter on the roadmap page updated.
- Roadmap split into two streams, Platform and Product, with a filter on the page. Product stream starts with T-017 and decision D-07.
- Added a CI/CD flow diagram as a second page (cicd.html) inside the roadmap artifact. Showing the planned test-then-live flow, with checks, backups, health checks, rollback and the fortnightly upstream sync.
- ai-playbook: added Moodle-in-Docker playbook (lessons from this deployment). Note: my commit also swept in seven other playbooks/skills from another session; checked, generic, left in place.
- Data moved from Docker volumes to folders: /opt/pokemoodle/<env>/pgdata and /moodledata (DATA_DIR in each env file). Counts matched before and after (2 users, 499 tables, 1 course; uploaded files copied). Rebuild test passed: image rebuilt with --no-cache and containers removed, marker row and file survived. Old Docker volumes (pokemoodle_* and pokemoodle-test_*) still exist as a fallback; remove once you are happy. Safety dumps in /opt/pokemoodle/backups/.
- Both sites live from /opt/pokemoodle on gemini-home: test (port 8081) and live (port 8082), each with its own database, Redis and files. Moved test from the home folder without data loss.
- Fixed pgbouncer: transaction pooling broke Moodle (cursors); now session pooling. Admin login on test failed because the generated password was never changed (and its file had been removed): reset with admin/cli/reset_password.php.
- T-003: test site live at https://pokemoodle-test.geminitech.co.nz (login page loads, no mixed content, IP address redirects to the https name). Learned: with Caddy passing the Host header, Moodle's reverseproxy must stay off or it returns an error.
- Caddy entries and DNS for both names created by you; live name returns 502 until the live instance runs on port 8082.
- T-001: Docker setup built and started on gemini-home (Apache, PostgreSQL 17, pgbouncer, Redis, cron). Fixes found on first run: PostgreSQL 17 needed, entrypoint permissions, cron user. Data lives in named volumes (pgdata, moodledata), which survive rebuilds.
- T-014: Moodle 5.3 RC2 installs and runs from a fresh database.
- Hostnames decided: pokemoodle-test.geminitech.co.nz and pokemoodle.geminitech.co.nz, Caddy with automatic certificates. Wrote instance env examples, Caddy entries and VM setup steps (docker/README.md).
- D-06 approved: Moodle's Core workflow (push.yml) set to manual-only, and main-pokemoodle pushed to GitHub (4 commits).
- Branch strategy decided: main mirrors upstream (fast-forward only, pushed); main-pokemoodle holds our changes (3 commits locally, not pushed). Fortnightly: merge main into main-pokemoodle.
- Pushed main to the fork: now identical to upstream main (Moodle 5.3 RC2).
- Merged upstream main into main (fast-forward, 7,521 commits). Docker image now serves the public folder with Moodle's new routing rule; web port binds to a configurable address because Caddy runs in a separate Proxmox LXC.
- D-02 answered: Caddy (in a Proxmox LXC) handles HTTPS; Moodle containers use their own host ports behind it.
- D-03 answered: follow upstream main (latest Moodle). Added T-014 to move this copy onto it.
- D-05 answered: only you approve a go-live.
- ai-playbook scaffolded (folders, README) with the roadmap-page procedure as its first playbook.
- Chose Docker with Apache, PostgreSQL, Redis and pgbouncer.
- Agreed a test site (pokemoodle-test) and a live site (pokemoodle) on gemini-home.
- D-04: created the ai-playbook repo (empty) and added it to the session.
- Chose the name ai-playbook for the shared AI project.
- Roadmap moved from a markdown file to the published page plus this file.
