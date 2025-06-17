#!/bin/bash
set -euo pipefail

# Configuration
HOST_PORT=80         # Public port exposed on the host
CONTAINER_PORT=8080  # Port app listens on inside the container
TIMEOUT=60  # Max seconds to wait for health check
INTERVAL=5  # Seconds between health check retries

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting deployment on server..."

IMAGE_TAG="$1"
API_TOKEN="$2"
if [ -z "$IMAGE_TAG" ] || [ -z "$API_TOKEN" ]; then
    log "ERROR: No image tag or API token provided."
    log "Usage: $0 <image-tag> <api-token>"
    exit 1
fi
log "Pulling image flightlogscanner/flightlogscan:\"$IMAGE_TAG\" from Docker Hub..."
docker pull "flightlogscanner/flightlogscan:$IMAGE_TAG"

log "Removing existing container if present..."
docker stop flightlogscan 2>/dev/null || true
docker rm flightlogscan 2>/dev/null || true

log "Checking port $HOST_PORT availability..."
if lsof -i :$HOST_PORT; then
    log "ERROR: Another process *might* be using port $HOST_PORT."
    exit 1
fi

log "Starting new container with image tag $IMAGE_TAG..."
docker run -d \
    --platform linux/amd64 \
    -e API_TOKEN="$API_TOKEN" \
    -e SPRING_PROFILES_ACTIVE=prod \
    --name flightlogscan \
    --restart unless-stopped \
    -p $HOST_PORT:$CONTAINER_PORT \
    flightlogscanner/flightlogscan:"$IMAGE_TAG"

log "Starting health check (timeout: ${TIMEOUT}s)..."
start_time=$(date +%s)

while true; do
    if curl -sf --connect-timeout 5 http://localhost:$HOST_PORT/api/ping >/dev/null; then
        log "Health check passed!"
        break
    fi

    sleep $INTERVAL
    elapsed=$(( $(date +%s) - start_time ))

    if [ $elapsed -ge $TIMEOUT ]; then
        log "ERROR: Health check failed after ${TIMEOUT}s"
        log "Showing container logs:"
        docker logs flightlogscan --tail 50
        exit 1
    fi
    log "Waiting for service... (${elapsed}s elapsed)"
done

log "Pruning unused and old Docker images..."
docker image prune -f --filter "until=24h"

log "Deployment completed successfully"
