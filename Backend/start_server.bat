@echo off
set docker_name="server_docker"
docker stop %docker_name%
docker rm %docker_name%
md db

docker build -t cpp_docker .
docker run -d --name %docker_name% --mount type=bind,source="%cd%",target=/app --mount type=bind,source="%cd%/db",target=/var/lib/mysql -p 8080:8080/tcp -p 3306:3306  cpp_docker

TIMEOUT 20

docker exec -ti %docker_name% make run DEBUG=1
REM Uncomment the following line to run the tests
REM docker exec -ti %docker_name% make test










 