FROM ubuntu:bionic

# Fix key errors
RUN apt clean

# Install dependancies
RUN  dpkg --add-architecture i386 \ 
    && apt update -y \
    && apt install -y mailutils postfix curl wget \
    file tar bzip2 gzip unzip bsdmainutils python \
    util-linux ca-certificates binutils bc jq tmux \ 
    lib32gcc1 libstdc++6 lib32stdc++6 netcat \ 
    libcurl4-gnutls-dev:i386 libtcmalloc-minimal4:i386

# Install SteamCMD
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && apt install -y steamcmd

# Set up tf2server user
RUN useradd -ms /bin/bash tf2server
WORKDIR /home/tf2server/

# Download setup script
RUN wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh
RUN chown -R tf2server .

# Run setup script
USER tf2server
RUN bash linuxgsm.sh tf2server

ENV GSLT_TOKEN=

# Copy scripts and make executable.
COPY --chown=tf2server . .
RUN chmod +x verify.sh 
RUN ./verify.sh

ENTRYPOINT [ "./install.sh" ]
VOLUME [ "/home/tf2server/serverfiles" ]