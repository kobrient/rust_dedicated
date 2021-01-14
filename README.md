# rust_dedicated
Dedicated Rust Game Server in a Docker container

## Setup
1. Change permissions on `rust-data` folder to `777` so that Steam user within Docker container can read and write data to that directory.
This ensures that world and player data is persistent across container restarts.
```
chmod 0777 rust-data/
```
2. The container will require and use ports 28015/udp and 28016/(udp & tcp) so make sure to forward those to the host machine.
Port 28015 is for the game traffic and port 28016 is for the Web RCON management console

3. Change the default placeholder values in [runrust.sh](rust-scripts/runrust.sh) to what you want your server to use.

## Start the container
To start the container and then detach (recommended):
```
docker run -d -p 28015:28015/udp -p 28016:28016/udp -p 28016:28016/tcp -v $(pwd)/rust-data:/home/steam/rust/ -v $(pwd)/rust-scripts:/home/steam/rust-scripts/ --name=rust-dedicated cm2network/steamcmd:root /home/steam/rust-scripts/setup.sh
```
If you want to enter the container interactively for debug:
```
docker run -it -p 28015:28015/udp -p 28016:28016/udp -p 28016:28016/tcp -v $(pwd)/rust-data:/home/steam/rust/ -v $(pwd)/rust-scripts:/home/steam/rust-scripts/ --name=rust-dedicated cm2network/steamcmd:root bash
```

## Stopping and starting the container
```
docker container stop rust-dedicated
...
docker container start rust-dedicated
```
To remove the container in case you want to start a new one completely:
```
docker container rm rust-dedicated
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

