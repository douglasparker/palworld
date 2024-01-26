import os

# TODO: Get settings from DefaultPalWorldSettings.ini so that way any additional settings work as docker environmental variables the moment they get added.

DEFAULT_PALWORLD_SETTINGS = "/home/steam/Steam/steamapps/common/PalServer/DefaultPalWorldSettings.ini"
PALWORLD_SETTINGS = "/home/steam/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini"

STRING_SETTINGS = ["ServerName", "ServerDescription", "AdminPassword", "ServerPassword", "PublicIP", "Region", "BanListURL"]
NON_STRING_SETTINGS = ["Difficulty", "DayTimeSpeedRate", "NightTimeSpeedRate", "ExpRate", "PalCaptureRate", "PalSpawnNumRate", "PalDamageRateAttack", "PalDamageRateDefense", "PlayerDamageRateAttack", "PlayerDamageRateDefense", "PlayerStomachDecreaceRate", "PlayerStaminaDecreaceRate", "PlayerAutoHPRegeneRate", "PlayerAutoHpRegeneRateInSleep", "PalStomachDecreaceRate", "PalStaminaDecreaceRate", "PalAutoHPRegeneRate", "PalAutoHpRegeneRateInSleep", "BuildObjectDamageRate", "BuildObjectDeteriorationDamageRate", "CollectionDropRate", "CollectionObjectHpRate", "CollectionObjectRespawnSpeedRate", "EnemyDropItemRate", "DeathPenalty", "bEnablePlayerToPlayerDamage", "bEnableFriendlyFire", "bEnableInvaderEnemy", "bActiveUNKO", "bEnableAimAssistPad", "bEnableAimAssistKeyboard", "DropItemMaxNum", "DropItemMaxNum_UNKO", "BaseCampMaxNum", "BaseCampWorkerMaxNum", "DropItemAliveMaxHours", "bAutoResetGuildNoOnlinePlayers", "AutoResetGuildTimeNoOnlinePlayers", "GuildPlayerMaxNum", "PalEggDefaultHatchingTime", "WorkSpeedRate", "bIsMultiplay", "bIsPvP", "bCanPickupOtherGuildDeathPenaltyDrop", "bEnableNonLoginPenalty", "bEnableFastTravel", "bIsStartLocationSelectByMap", "bExistPlayerAfterLogout", "bEnableDefenseOtherGuildPlayer", "CoopPlayerMaxNum", "ServerPlayerMaxNum", "PublicPort", "RCONEnabled", "RCONPort", "bUseAuth"]

for V in STRING_SETTINGS:
    if(os.environ.get(V) != None):
        print(f"Updating configuration: {V}=\"{os.environ[V]}\"")

        with open(PALWORLD_SETTINGS, "r") as file:
            contents = file.read()

        config_start = contents.index(f"{V}=")
        config_end = contents.index(",", config_start)

        contents = contents.replace(contents[config_start:config_end], f'{V}="{os.environ[V]}"')

        with open(PALWORLD_SETTINGS, "w") as file:
            file.write(contents)

for V in NON_STRING_SETTINGS:
    if(os.environ.get(V) != None):
        print(f"Updating configuration: {V}={os.environ[V]}")

        with open(PALWORLD_SETTINGS, "r") as file:
            contents = file.read()

        config_start = contents.index(f"{V}=")
        config_end = contents.index(",", config_start)

        contents = contents.replace(contents[config_start:config_end], f'{V}={os.environ[V]}')

        with open(PALWORLD_SETTINGS, "w") as file:
            file.write(contents)