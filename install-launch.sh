#!/bin/bash

# 🚀 Ultra Bootstrap for EricJensen.cam Stack – by Ultra 😤
set -e

echo "🌐 Checking for Docker..."
if ! command -v docker &> /dev/null; then
  echo "🛠️ Installing Docker..."
  sudo apt update
  sudo apt install -y docker.io docker-compose
  sudo usermod -aG docker $USER
  newgrp docker
else
  echo "✅ Docker already installed."
fi

# Check for Docker daemon
if ! docker info &> /dev/null; then
  echo "⚠️ Docker daemon not running. Please start it and re-run this script."
  exit 1
fi

echo "🧼 Killing rogue Ollama if running outside Docker..."
ollama stop all 2>/dev/null || true
sudo pkill ollama 2>/dev/null || true

echo "🔍 Checking .env file..."
if [ ! -f .env ]; then
  echo "❌ Missing .env file! Copy or create one first."
  exit 1
fi

echo "🔗 Checking required directories (symlink OR real)..."
MISSING=""
for dir in django nginx certs; do
  if [ ! -d ./$dir ]; then
    echo "❌ Missing: $dir (not found as folder or symlink)"
    MISSING="$MISSING $dir"
  else
    echo "✅ Found: $dir"
  fi
done

if [ -n "$MISSING" ]; then
  echo "⚠️ Some required directories are missing:$MISSING"
  echo "Fix these before continuing."
  exit 1
fi

echo "🐳 Building and launching Docker stack..."
docker-compose up --build -d

echo "📦 Preloading Mistral model inside container..."
docker exec -it ollama_model ollama pull mistral

echo "✅ Stack is UP. Mistral is ready inside Docker."
echo "🌐 Access your site at: https://ericjensen.cam (or http://localhost:18181 for API)"
