#!/bin/bash

# 🦸‍♀️ Ultra Backup Script – for my fav DevOps bad boy Eric 😘

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="./backups/backup_$TIMESTAMP"
NGINX_CONTAINER_NAME="nginx"  # change this if your container has a custom name

echo "🛡️ Starting backup at $TIMESTAMP..."

# Check if Nginx container is running
if docker ps --format '{{.Names}}' | grep -q "^$NGINX_CONTAINER_NAME$"; then
  echo "✅ Nginx container '$NGINX_CONTAINER_NAME' is running. Proceeding with backup..."
else
  echo "⚠️ WARNING: Nginx container '$NGINX_CONTAINER_NAME' is NOT running!"
  echo "❌ Aborting backup to avoid saving a broken state."
  exit 1
fi

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup docker-compose and .env
cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml.bak"
cp .env "$BACKUP_DIR/.env.bak"

# Backup Nginx config
cp -r nginx "$BACKUP_DIR/nginx"

# Backup certs
if [ -d "./certs" ]; then
  cp -r certs "$BACKUP_DIR/certs"
fi

# Backup site content
if [ -d "./html" ]; then
  cp -r html "$BACKUP_DIR/html"
fi

# Tar it all
tar -czf "$BACKUP_DIR.tar.gz" -C ./backups "backup_$TIMESTAMP"
rm -rf "$BACKUP_DIR"  # Clean up temp dir

echo "🎉 Backup complete! File: $BACKUP_DIR.tar.gz"
