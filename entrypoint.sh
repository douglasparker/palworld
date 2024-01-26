#!/bin/bash

# Palworld Server: Install, Update, and Validate

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

if [[ ${SERVER_NAME+x} ]]; then
    sed -i 's/ServerName=.*,/ServerName="'$SERVER_NAME'",/g' /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
fi

if [[ ${SERVER_DESCRIPTION+x} ]]; then
    sed -i 's/ServerDescription=.*,/ServerDescription="'$SERVER_DESCRIPTION'",/g' /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
fi

if [[ ${SERVER_PORT+x} ]]; then
    sed -i 's/PublicPort=.*,/PublicPort='$SERVER_PORT',/g' /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
fi

if [[ ${PAL_EGG_HATCHING_TIME+x} ]]; then
    sed -i 's/PalEggDefaultHatchingTime=.*,/PalEggDefaultHatchingTime='$PAL_EGG_HATCHING_TIME',/g' /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
fi

# Palworld Server: Start

eval /home/steam/Steam/steamapps/common/PalServer/PalServer.sh &
SERVER_PID=$!
wait $SERVER_PID
exit $?
