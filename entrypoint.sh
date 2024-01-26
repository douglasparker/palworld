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

declare -a STRING_CONFIGS=("ServerName" "ServerDescription" "AdminPassword" "ServerPassword" "PublicIP" "Region" "BanListURL")
declare -a NON_STRING_CONFIGS=("Difficulty" "DayTimeSpeedRate" "NightTimeSpeedRate" "ExpRate" "PalCaptureRate" "PalSpawnNumRate" "PalDamageRateAttack" "PalDamageRateDefense" "PlayerDamageRateAttack" "PlayerDamageRateDefense" "PlayerStomachDecreaceRate" "PlayerStaminaDecreaceRate" "PlayerAutoHPRegeneRate" "PlayerAutoHpRegeneRateInSleep" "PalStomachDecreaceRate" "PalStaminaDecreaceRate" "PalAutoHPRegeneRate" "PalAutoHpRegeneRateInSleep" "BuildObjectDamageRate" "BuildObjectDeteriorationDamageRate" "CollectionDropRate" "CollectionObjectHpRate" "CollectionObjectRespawnSpeedRate" "EnemyDropItemRate" "DeathPenalty" "bEnablePlayerToPlayerDamage" "bEnableFriendlyFire" "bEnableInvaderEnemy" "bActiveUNKO" "bEnableAimAssistPad" "bEnableAimAssistKeyboard" "DropItemMaxNum" "DropItemMaxNum_UNKO" "BaseCampMaxNum" "BaseCampWorkerMaxNum" "DropItemAliveMaxHours" "bAutoResetGuildNoOnlinePlayers" "AutoResetGuildTimeNoOnlinePlayers" "GuildPlayerMaxNum" "PalEggDefaultHatchingTime" "WorkSpeedRate" "bIsMultiplay" "bIsPvP" "bCanPickupOtherGuildDeathPenaltyDrop" "bEnableNonLoginPenalty" "bEnableFastTravel" "bIsStartLocationSelectByMap" "bExistPlayerAfterLogout" "bEnableDefenseOtherGuildPlayer" "CoopPlayerMaxNum" "ServerPlayerMaxNum" "PublicPort" "RCONEnabled" "RCONPort" "bUseAuth")

for CONFIG in ${STRING_CONFIGS[@]}
do
    if [[ ${!CONFIG+x} ]]; then
        echo "Updating configuration: $CONFIG=${!CONFIG}"
        sed -i "s/$CONFIG=.*,/$CONFIG=${!CONFIG},/g" /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
done

for CONFIG in ${NON_STRING_CONFIGS[@]}
do
    if [[ ${!CONFIG+x} ]]; then
        echo "Updating configuration: $CONFIG=${!CONFIG}"
        sed -i "s/$CONFIG=.*,/$CONFIG=${!CONFIG},/g" /home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
    fi
done

# Palworld Server: Start

eval /home/steam/Steam/steamapps/common/PalServer/PalServer.sh &
SERVER_PID=$!
wait $SERVER_PID
exit $?
