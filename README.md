# Immich_server
.env and .yml files for immich server

commands
docker compose up -d

close
docker compose down

Backup of example takeout
./immich-go -server=http://172.20.148.18:2283 -key=5hFqcL5RNaxPZtZbFa5HAwxQdkEcIdpqhsopdFww upload -google-photos takeout-20250123T031447Z-00*.zip 


Manual Backup of Immich
sudo docker exec -t immich_postgres pg_dumpall --clean --if-exists --username=postgres | gzip > " /media/hmm/Media_server1/Manual_Backups/dump.sql.gz"

Add Aias to bashrc for clean launch and shutdown for Immich Docker Compose
alias immich='cd immich_app && docker compose pull && docker compose up -d && cd ..'
alias immich_down='cd immich_app && docker compose down && cd ..'


## Kria KR260 setup (`kria/`)

Production config for Immich on an AMD Kria KR260 (Ubuntu, arm64, library on a separate data drive).

- `kria/docker-compose.yml` - Immich plus **Watchtower** (daily auto-update of the server and ML containers only; Postgres and Redis are pinned by digest) and a private **ntfy** server for update alerts (reach it over Tailscale, e.g. `http://<kria-tailscale-ip>:8088`, topic `kria-immich`).
- `kria/example.env` - copy to `.env` and set `DB_PASSWORD`. Never commit the real `.env`.
- `kria/scripts/immich-db-dump.sh` - nightly `pg_dumpall` (integrity-checked, keeps 7). Cron: `30 3 * * *`.
- `kria/scripts/immich-library-backup.sh` - nightly rsync of originals to a second folder on the data drive; deleted/changed files are kept 60 days. Runs as root in a container because some library files are root-only. Same-drive safety net only, not a replacement for an off-drive copy. Cron: `0 2 * * *`.
- `kria/scripts/immich-watchdog.sh` - restarts `immich_server` if its API fails 3 checks in a row and alerts via ntfy. Cron: `*/5 * * * *`.
- `kria/scripts/docker-prune-monthly.sh` - removes unused images older than 30 days. Cron: `0 5 1 * *`.
- `kria/scripts/pull-kria-immich-db.sh` - run on another machine to pull the latest DB dumps (keeps 3).

Manual update: `docker compose pull && docker compose up -d`. Take a DB dump first.
