#!/bin/bash

echo "🚀 Starting OrderMS with Docker Compose..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Remove old images (optional)
read -p "Do you want to remove old images? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🗑️ Removing old images..."
    docker-compose down --rmi all
fi

# Build and start containers
echo "🔨 Building and starting containers..."
docker-compose up --build -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 10

# Check container status
echo "📊 Container status:"
docker-compose ps

echo ""
echo "✅ OrderMS started successfully!"
echo ""
echo "🌐 Access URLs:"
echo "   - Application: http://localhost:8080"
echo "   - RabbitMQ Management: http://localhost:15672 (admin/123)"
echo "   - MongoDB: localhost:27017"
echo ""
echo "📝 Useful commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop: docker-compose down"
echo "   - Restart: docker-compose restart" 