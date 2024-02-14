$docker_name = "server_docker"

mkdir db -ErrorAction SilentlyContinue

function Wait {
    param(
        [int]$duration
    )

    $interval = 1
    $iterations = [math]::Floor($duration / $interval)

    for ($i = 0; $i -le $iterations; $i++) {
        $percent = [math]::Floor($i * 100 / $iterations)
        Write-Host -NoNewline ("`r[")

        for ($j = 0; $j -lt $percent / 2; $j++) {
            Write-Host -NoNewline ("=")
        }

        Write-Host -NoNewline (">{0,2}%" -f $percent)

        for ($j = $percent / 2; $j -lt 50; $j++) {
            Write-Host -NoNewline (" ")
        }

        Write-Host -NoNewline ("]")
        Start-Sleep -Seconds $interval
    }
}

docker stop $docker_name
docker rm $docker_name

docker build -t cpp_docker .
docker run -d --name $docker_name --mount type=bind,source="${PWD}",target=/app --mount type=bind,source="${PWD}/db/",target=/var/lib/mysql cpp_docker

# Start measuring time for docker exec make
$make_start_time = (Get-Date).ToUniversalTime().Ticks

# Execute the command docker exec make
docker exec $docker_name make

# End measuring time for docker exec make
$make_end_time = (Get-Date).ToUniversalTime().Ticks

# Calculate the duration of docker exec make in seconds
$make_duration = ($make_end_time - $make_start_time) / 1e7

# Calculate the duration to wait in the wait function
$wait_duration = 20 #- $make_duration

# Check if the wait duration is greater than 0 before calling the Wait function
if ($wait_duration -gt 0) {
    Wait $wait_duration
} else {
    Write-Host "The command docker exec make took longer than 20 seconds."
}

docker exec $docker_name make run
