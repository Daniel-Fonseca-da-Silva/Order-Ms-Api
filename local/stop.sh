#!/bin/bash

echo "🛑 Stopping OrderMS..."

# Stop containers
docker-compose down

echo "✅ Containers stopped successfully!"

# Ask if you want to remove volumes
read -p "Do you want to remove volumes? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️ Removing volumes..."
    docker-compose down -v
    echo "✅ Volumes removed!"
fi 