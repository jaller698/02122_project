@echo off
set docker_name="server_docker"
docker stop %docker_name%
docker rm %docker_name%
md db

docker build -t cpp_docker .
docker run -d --name %docker_name% --mount type=bind,source="%cd%",target=/app --mount type=bind,source="%cd%/db",target=/var/lib/mysql -p 8080:8080/tcp cpp_docker

TIMEOUT 20

start docker exec -ti %docker_name% make run
// Uncomment the following line to run the tests
// docker exec -ti %docker_name% make test










 