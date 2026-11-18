#!/bin/bash
# Remove unused Docker images older than 30 days (cron: monthly).
docker image prune -a -f --filter "until=720h" | tail -1
