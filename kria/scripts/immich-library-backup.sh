#!/bin/bash
# Same-drive safety copy of Immich originals, run as root inside a throwaway rsync container
# (some library files are root-only, so a normal user would silently skip them).
# Deleted/changed files are kept in deleted/<date> for 60 days.
# One-time: docker build -t rsync-local - <<< $'FROM alpine\nRUN apk add --no-cache rsync'
root=/mnt/media_server; day=$(date +%F); log=$root/immich-library-backup/backup.log
mkdir -p $root/immich-library-backup/current $root/immich-library-backup/deleted
exec 9>/tmp/immich-lib-backup.lock; flock -n 9 || exit 0
if nice -n 19 docker run --rm -v $root:/m rsync-local rsync -a --partial --backup \
     --backup-dir=/m/immich-library-backup/deleted/$day \
     /m/im/library /m/im/upload /m/im/profile /m/immich-library-backup/current/ >> $log 2>&1; then
  echo "ok $(date)" >> $log
else
  echo "FAILED $(date)" >> $log
  curl -s -H "Priority: high" -d "Immich library backup FAILED, see $log" localhost:8088/kria-immich >/dev/null
fi
find $root/immich-library-backup/deleted -mindepth 1 -maxdepth 1 -mtime +60 -exec docker run --rm -v $root:/m alpine rm -rf {} + 2>/dev/null
