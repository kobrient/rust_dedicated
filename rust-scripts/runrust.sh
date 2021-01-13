#!/bin/sh

if [ -f "RustDedicated" ]; then
    clear
    while :
    do
      exec ./RustDedicated -batchmode -nographics \
      -server.ip 0.0.0.0 \
      -server.port 28015 \
      -server.tickrate 20 \
      -server.maxplayers 75 \
      -server.hostname "ServerHostname" \
      -server.identity "ServerIdentity" \
      -server.level "Procedural Map" \
      -server.seed 12345 \
      -server.worldsize 3000 \
      -server.saveinterval 300 \
      -server.globalchat true \
      -server.description "ServerDescription" \
      -rcon.ip 0.0.0.0 \
      -rcon.port 28016 \
      -rcon.web 1 \
      -rcon.password "RconPassword"

      echo "\nRestarting server...\n" done
    done

else
    echo "ERROR: RustDedicated not found"
    exit 1
fi
