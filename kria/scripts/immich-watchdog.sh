#!/bin/bash
# Restart immich_server if its API stops answering for 3 consecutive checks (cron: */5). Alerts via local ntfy.
s=/tmp/immich-watchdog.fails; n=$(cat $s 2>/dev/null || echo 0)
if curl -sf -m 10 localhost:2283/api/server/ping >/dev/null; then
  [ "$n" -ge 3 ] && curl -s -d "Immich recovered" localhost:8088/kria-immich >/dev/null
  echo 0 > $s
else
  n=$((n+1)); echo $n > $s
  if [ "$n" -eq 3 ]; then
    curl -s -H "Priority: high" -d "Immich not responding, restarting container" localhost:8088/kria-immich >/dev/null
    docker restart immich_server >/dev/null 2>&1
  fi
fi
