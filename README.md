# rust_dedicated
Dedicated Rust Game Server in a Docker container

## Prerequisites
1. Docker
2. Access to [dockerhub](https://hub.docker.com/r/cm2network/steamcmd/) to pull images
3. Ability to forward ports to the host

## Setup
1. Change permissions on `rust-data` folder to `777` so that Steam user within Docker container can read and write data to that directory.
This ensures that world and player data is persistent across container restarts.
```
chmod 0777 rust-data/
```
2. The container will require and use ports 28015/udp and 28016/(udp & tcp) so make sure to forward those to the host machine.
Port 28015 is for the game traffic and port 28016 is for the Web RCON management console

3. Change the default placeholder values in [runserver.sh](rust-scripts/runserver.sh) to what you want your server to use.

## Start the container
To spin up the container with docker-compose:
```
docker-compose up
```
If compose is not available, to start the container manually and then detach:
```
docker run -d -p 28015:28015/udp -p 28016:28016/udp -p 28016:28016/tcp -v $(pwd)/rust-data:/home/steam/rust/ -v $(pwd)/rust-scripts:/home/steam/rust-scripts/ --name=rust-dedicated cm2network/steamcmd:root /home/steam/rust-scripts/runserver.sh
```
The container typically takes 4-5 minutes to spin up so it won't work if you try to connect immediately.

If something goes amiss and you want to enter the container interactively for debug:
```
docker-compose -f docker-compose.scratch.yml run --service-ports rust-dedicated-scratch
```
or
```
docker run -it -p 28015:28015/udp -p 28016:28016/udp -p 28016:28016/tcp -v $(pwd)/rust-data:/home/steam/rust/ -v $(pwd)/rust-scripts:/home/steam/rust-scripts/ --name=rust-dedicated-scratch cm2network/steamcmd:root bash
```

## Managing the container
To stop the server, input Ctrl-C from the shell the container is running in OR
```
docker kill --signal="SIGINT" <container-id>
```
To remove the container in case you want to start a new one completely:
```
docker container rm <container-id | container-name>
```

## Connecting to the sever
Open up your Rust game client and hit `F1` to bring up the console.
Enter
```
client.connect {server ip address}:28015
```
If hosting the server on the same machine that is running the client, use `localhost` (127.0.0.1)

## Acknowledgments
Thanks to @cm2network's steamcmd docker container

[https://hub.docker.com/r/cm2network/steamcmd/]

[https://github.com/CM2Walki/steamcmd]

