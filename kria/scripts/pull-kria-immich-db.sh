#!/bin/bash
d=$HOME/backups/kria-immich-db
rsync -a --partial -e "ssh -o BatchMode=yes -o ConnectTimeout=15" "kria:backups/immich_db_*.sql.gz" "$d/" || exit 1
ls -1t "$d"/immich_db_*.sql.gz | tail -n +4 | xargs -r rm --
