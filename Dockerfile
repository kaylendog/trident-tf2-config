FROM debian:buster-slim

# Install required dependancies.
RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6=8.3.0-6 \
    lib32gcc1=1:8.3.0-6 \
    wget=1.20.1-1.1 \
    ca-certificates=20190110 

WORKDIR /home/steamcmd

RUN wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -

WORKDIR /home/

RUN [ "./steamcmd/steamcmd.sh", "+login anonymous", "+force_install_dir ./instances", "+app_update 232250 validate", "+quit"]

# Install sourcemod
RUN cd ./instances/tf2/tf  \
    && wget -qO- https://raw.githubusercontent.com/CM2Walki/TF2/master/etc/cfg.tar.gz | tar xvzf - \
    && wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar xvzf - \
    && wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar xvzf - 

# Clean up image
RUN apt-get remove --purge -y \
    wget \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /home/instances/tf2

# Copy configuration
COPY ./tf ./tf
COPY ./tf2_update.txt .
COPY ./sourcemod/ ./addons/sourcemod

VOLUME [ "/home/instances/tf2" ]

ENV TOKEN=

ENTRYPOINT ./srcds_run \
    -game tf \
    -console \
    -autoupdate \
    -steam_dir /home/steamcmd \
    -steamcmd_script ./tf2_update.txt \
    +sv_pure 1 \ 
    +randommap \ 
    +maxplayers 24 \ 
    +sv_setsteamaccount ${TOKEN}

EXPOSE 27015/tcp 27015/udp 27020/udp
