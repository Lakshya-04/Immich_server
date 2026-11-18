#!/bin/bash
# Same-drive safety copy of Immich originals. Deleted/changed files are kept in deleted/<date>.
src=/mnt/media_server/im; dst=/mnt/media_server/immich-library-backup
mkdir -p $dst/current $dst/deleted
exec 9>/tmp/immich-lib-backup.lock; flock -n 9 || exit 0
nice -n 19 ionice -c3 rsync -a --partial --backup --backup-dir=$dst/deleted/$(date +%F) \
  $src/library $src/upload $src/profile $dst/current/ >> $dst/backup.log 2>&1 \
  && echo "ok $(date)" >> $dst/backup.log || echo "FAILED $(date)" >> $dst/backup.log
find $dst/deleted -mindepth 1 -maxdepth 1 -mtime +60 -exec rm -rf {} +
