#!/bin/bash
set -o pipefail
d=$HOME/backups; f=$d/immich_db_$(date +%F).sql.gz
if nice -n 15 docker exec immich_postgres pg_dumpall --clean --if-exists --username=postgres | gzip > $f.tmp && gzip -t $f.tmp; then
  mv $f.tmp $f; ls -1t $d/immich_db_*.sql.gz | tail -n +8 | xargs -r rm --
else rm -f $f.tmp; echo "dump failed $(date)" >> $d/dump.log; exit 1; fi
