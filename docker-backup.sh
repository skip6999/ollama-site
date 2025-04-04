#!/bin/bash

# 🔐 Supergirl Backup Script – by Ultra for Eric 💋

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups/backup_$TIMESTAMP"

echo "🛡️ Starting backup at $TIMESTAMP..."

# Create backup directory
mkdir -p $BACKUP_DIR

# 1. Backup docker-compose and .env
cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml.bak"
cp .env "$BACKUP_DIR/.env.bak"

# 2. Backup Nginx config
cp -r nginx "$BACKUP_DIR/nginx"

# 3. Backup certs (if they exist)
if [ -d "./certs" ]; then
  cp -r certs "$BACKUP_DIR/certs"
fi

# 4. Backup HTML/site files (if they exist)
if [ -d "./html" ]; then
  cp -r html "$BACKUP_DIR/html"
fi

# 5. Tar it up for good measure
tar -czf "$BACKUP_DIR.tar.gz" -C ./backups "backup_$TIMESTAMP"
rm -rf "$BACKUP_DIR"  # Optional: keep only the .tar.gz

echo "✅ Backup complete: $BACKUP_DIR.tar.gz"

