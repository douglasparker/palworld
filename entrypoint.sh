#!/bin/bash

./steamcmd.sh +login $STEAM_USERNAME +app_update 2394010 validate +quit

#tail -f --retry "${ARK_PATH}/Saved/Logs/ShooterGame.log" &

# Start the server
eval /home/steam/Steam/steamapps/common/PalServer/PalServer.sh &
#eval $SERVER_CMD > /dev/null 2>&1 &

SERVER_PID=$!
wait $SERVER_PID
exit $?
