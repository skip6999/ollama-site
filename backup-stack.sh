#!/bin/bash

# 🔐 Ultra Stack Backup Script
# Backs up your current ollama-site stack into a .tar.gz archive

BACKUP_NAME="ollama-site-backup_20250404_103535.tar.gz"
BACKUP_DIR="$HOME/ollama-backups"

echo "📁 Creating backup folder at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

echo "📦 Archiving files..."
tar -czvf "$BACKUP_DIR/$BACKUP_NAME" \
  docker-compose.yml \
  .env \
  nginx \
  django \
  certs \
  porkbun.ini \
  static \
  chat \
  docker-backup.sh \
  install-and-launch.sh \
  clean-rebuild.sh 2>/dev/null || true

echo "✅ Backup complete: $BACKUP_DIR/$BACKUP_NAME"
