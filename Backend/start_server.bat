@echo off
REM Description: This script is used to start the server in a docker container.
REM Written by Christian

set docker_name="server_docker"
docker stop %docker_name%
docker rm %docker_name%
md db

docker build -t cpp_docker .
docker run -d --name %docker_name% --mount type=bind,source="%cd%",target=/app --mount type=bind,source="%cd%/db",target=/var/lib/mysql -p 8080:8080/tcp -p 3306:3306  cpp_docker

TIMEOUT 20

if "%1"=="test" (
    docker exec -ti %docker_name% make test
) else (
    docker exec -ti %docker_name% make DEBUG=1 run
)











 