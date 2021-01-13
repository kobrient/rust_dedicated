#!/bin/bash

scripts=/home/steam/rust-scripts

$scripts/dependencies.sh
$scripts/steamcmd_app.sh
cd /home/steam/rust
sudo -u steam $scripts/runrust.sh
