#!/bin/bash

#Install and run the gameserver. Try to die gracefully and leave breadcrumbs.

#For SteamCMD
game=rust
appid=258550
installdir=/home/steam/$game

#Script vars
server_pid=-1
timeout=30
server_pidfile="${game}_server.pid"
use_logfiles=false
stdout_logfile="${game}_stdout.log"
stderr_logfile="${game}_stderr.log"

#Server specific vars
server_hostname="ServerHostname"
server_identity="ServerIdentity"
server_description="ServerDescription"
server_rcon_password="RconPassword"
server_executable="RustDedicated"

#Space separated
dependencies="libsqlite3-dev sudo "

main() {
    dependencies
    steamcmd
    cd $installdir
    run_server
}

dependencies() {
    #Skip dependencies if we're not root/sudo
    if [ $(id -u) -eq 0 ]; then
        apt update
        apt install --assume-yes $dependencies
    else
        echo "WARN: Skipping dependencies because you're not root"
    fi
}

steamcmd() {
    mkdir -p $installdir
    /home/steam/steamcmd/steamcmd.sh +login anonymous +force_install_dir $installdir +app_update $appid +quit
}

shutdown() {
    if [ $server_pid -eq -1 ]; then
        echo "Server is not running yet - aborting startup"
        exit
    fi
    kill -INT $server_pid
    shutdown_timeout=$(($(date +%s)+$timeout))
    while [ -d "/proc/$server_pid" ]; do
        if [ $(date +%s) -gt $shutdown_timeout ]; then
            shutdown_timeout=$(($(date +%s)+$timeout))
            echo "Timeout while waiting for server to shutdown - sending KILL to PID $server_pid"
            kill -KILL $server_pid
        fi
        echo "Waiting for server with PID $server_pid to shutdown"
        sleep 6
    done
    echo "Shutdown complete"
    exit
}

run_server() {
    if [ -f $server_executable ]; then
        echo "Starting server PRESS CTRL-C to exit"

#        sudo -u steam ./$server_executable -batchmode -nographics \

        if [ "$use_logfiles" = true ] ; then
            ./$server_executable -batchmode -nographics \
            -server.ip 0.0.0.0 \
            -server.port 28015 \
            -server.tickrate 20 \
            -server.maxplayers 75 \
            -server.hostname "$server_hostname" \
            -server.identity "$server_identity" \
            -server.level "Procedural Map" \
            -server.seed 12345 \
            -server.worldsize 3000 \
            -server.saveinterval 300 \
            -server.globalchat true \
            -server.description "$server_description" \
            -rcon.ip 0.0.0.0 \
            -rcon.port 28016 \
            -rcon.web 1 \
            -rcon.password "$server_rcon_password" \
            > $stdout_logfile 2> $stderr_logfile &
        else
            ./$server_executable -batchmode -nographics \
            -server.ip 0.0.0.0 \
            -server.port 28015 \
            -server.tickrate 20 \
            -server.maxplayers 75 \
            -server.hostname "$server_hostname" \
            -server.identity "$server_identity" \
            -server.level "Procedural Map" \
            -server.seed 12345 \
            -server.worldsize 3000 \
            -server.saveinterval 300 \
            -server.globalchat true \
            -server.description "$server_description" \
            -rcon.ip 0.0.0.0 \
            -rcon.port 28016 \
            -rcon.web 1 \
            -rcon.password "$server_rcon_password" &
        fi

        server_pid=$!
        echo $server_pid > $server_pidfile
        wait $server_pid
    else
        echo "ERROR: $server_executable not found"
        exit 1
    fi
}

trap shutdown SIGINT SIGTERM
main
