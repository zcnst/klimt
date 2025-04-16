default:
    @echo 'Klimt commands for local development'

show-docker:
    @docker ps --format "table {{{{.Names}}\t{{{{.Image}}\t{{{{.Status}}\t{{{{.Ports}}\t{{{{.Networks}}\t{{{{.Size}}" | awk 'NR==1 {print "\033[1;34m" $0 "\033[0m"; next} {print "\033[1;32m" $0 "\033[0m"}'
    @echo ''

build:
    @docker compose down
    @echo 'Build docker images and start containers:'
    @docker build --progress=quiet -f Dockerfile.app -t app:latest .
    @echo '✅ Images built'
    @echo ''
    @docker compose up -d --build --force-recreate
    @echo ''
    @just show-docker

build-app-image:
    docker build --progress=plain -f Dockerfile.app -t app:latest .