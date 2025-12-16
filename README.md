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
