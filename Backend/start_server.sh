#! /bin/bash
docker_name="server_docker"

mkdir -p db


wait() {
    local duration=$1
    local interval=1
    local iterations=$((duration / interval))

    for ((i = 0; i <= iterations; i++)); do
        local percent=$((i * 100 / iterations))
        printf "\r["
        for ((j = 0; j < percent / 2; j++)); do
            printf "="
        done
        printf ">%2d%%" "$percent"
        for ((j = percent / 2; j < 50; j++)); do
            printf " "
        done
        printf "]"
        sleep $interval
    done

    echo ""
}

docker stop $docker_name
docker rm $docker_name

docker build -t cpp_docker .
docker run -id --name $docker_name --mount type=bind,source="$(pwd)"/,target=/app --mount type=bind,source="$(pwd)"/db/,target=/var/lib/mysql -p 8080:8080/tcp -p3306:3306  cpp_docker

# Start measuring time
start_time=$(date +%s)

# Execute the command docker exec make
docker exec $docker_name make 

# End measuring time
end_time=$(date +%s)

# Calculate the time taken in seconds
time_taken=$((end_time - start_time))

# Check if the "db" folder exists
if [ -d "db" ]; then
    echo "Skipping most of wait function as 'db' folder exists."
    wait 4
else
    wait 20 - $time_taken
fi

gnome-terminal --window-with-profile=default -- docker exec -it $docker_name make DEBUG=1 run 
if [ "$1" = "test" ]
then
    echo "Running tests"
    wait 3
    docker exec -i $docker_name make DEBUG=1 test
else 
    echo "Not running tests"
fi

