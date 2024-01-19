FROM cm2network/steamcmd
ENV STEAM_PATH=${HOME}/.steam/steam
ENV GAME_PATH=${STEAM_PATH}/steamapps/common/PalServer

USER root
RUN mkdir -p /home/steam/Steam/steamapps/common/PalServer && chown steam:steam /home/steam/Steam/steamapps/common/PalServer
USER steam

COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
WORKDIR $HOME
ENTRYPOINT ["/home/steam/entrypoint.sh"]
