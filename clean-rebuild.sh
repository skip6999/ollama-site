#!/bin/bash

# 💣 Ultra Stack Teardown – Safe Project-Synced Clean for ollama-site

echo "🧨 Tearing down ollama-site stack..."

# Step 1: Tear down Docker Compose stack and volumes
docker-compose down --volumes --remove-orphans

# Step 2: Remove named volume if it exists
echo "🧼 Removing named volume: postgres_data"
docker volume rm postgres_data 2>/dev/null || true

# Step 3: Remove custom network if it exists
echo "🧼 Removing custom network: ollama_net"
docker network rm ollama_net 2>/dev/null || true

# Step 4: Optionally clean up old unused Docker data (commented out by default)
# echo "🧹 Optional: Full Docker system prune (uncomment to enable)"
# docker system prune -a --volumes -f

echo "✅ Stack teardown complete. Project volumes and network removed."
echo "🔁 To rebuild, run: ./install-and-launch.sh"
