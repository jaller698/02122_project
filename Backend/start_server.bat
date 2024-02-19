@echo off
set docker_name="server_docker"
docker stop %docker_name%
docker rm %docker_name%
md db

docker build -t cpp_docker .
docker run -d --name %docker_name% --mount type=bind,source="%cd%",target=/app --mount type=bind,source="%cd%/db",target=/var/lib/mysql -p 8080:8080/tcp cpp_docker

TIMEOUT 20

// Either run the server or run the server in seperate thread and then test
if %1%=="test" (
    start docker exec -ti %docker_name% make run
    docker exec -ti %docker_name% make test
) else (
    docker exec -ti %docker_name% make run
)








