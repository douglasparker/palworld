#!/bin/bash

# Palworld Server: Install, Update, and Validate

if [[ "$PUID" -eq 0 ]] || [[ "$PGID" -eq 0 ]]; then
    echo "[ERROR]: Running as root is not supported!"
    exit 1
fi

echo "[INFO]: Executing usermod..."
usermod --non-unique --uid "$($PUID -u)" steam
groupmod --non-unique --gid "$($PGID -g)" steam

su - steam
echo "[INFO]: Running as $(whoami) with ID: $(id -u) and GID: $(id -g)."

./steamcmd.sh +login $STEAM_USERNAME +app_update 2394010 validate +quit

DEFAULT_PALWORLD_SETTINGS="/home/steam/Steam/steamapps/common/PalServer/DefaultPalWorldSettings.ini"
PALWORLD_SETTINGS="/home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

# Palworld Server: First time initialization

if [ ! -f $PALWORLD_SETTINGS ]; then
    echo "Starting Palworld Server..."

    eval /home/steam/Steam/steamapps/common/PalServer/PalServer.sh &
    SERVER_PID=$!

    echo "Waiting for Palworld to start for the first time..."

    while [ ! -f $PALWORLD_SETTINGS ]
    do
        cp -p "$DEFAULT_PALWORLD_SETTINGS" "$PALWORLD_SETTINGS"
        sleep 1
    done

    echo "Palworld has successfully started."

    cp -p $DEFAULT_PALWORLD_SETTINGS $PALWORLD_SETTINGS

    echo "Shutting down Palworld Server..."
    kill $SERVER_PID
    sleep 5
    echo "Palworld Server has shut down successfully."
fi

# Palworld Server: Update Server Settings

python3 /home/steam/config.py

# Palworld Server: Start

eval /home/steam/Steam/steamapps/common/PalServer/PalServer.sh &
SERVER_PID=$!
wait $SERVER_PID
exit $?
