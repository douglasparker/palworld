FROM cm2network/steamcmd:root-bookworm
ENV STEAM_PATH=${HOME}/.steam/steam
ENV GAME_PATH=${STEAM_PATH}/steamapps/common/PalServer

RUN apt update && apt install python3 -y && mkdir -p /home/steam/Steam/steamapps/common/PalServer && chown steam:steam /home/steam/Steam/steamapps/common/PalServer

COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
COPY --chown=steam:steam config.py /home/steam/config.py
WORKDIR $HOME
ENTRYPOINT ["/home/steam/entrypoint.sh"]
