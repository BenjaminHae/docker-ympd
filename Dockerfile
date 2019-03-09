FROM ubuntu:18.04
MAINTAINER @BenjaminHae https://github.com/BenjaminHae

# https://docs.docker.com/engine/reference/builder/#arg

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -q --yes --no-install-recommends \
    pulseaudio-utils mpd mpc \
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
    
RUN mkdir -p /var/lib/mpd/music \
    && mkdir -p /var/lib/mpd/playlists \
    && mkdir -p /var/lib/mpd/database \
    && mkdir -p /var/log/mpd/ \
    && chown -R ${user} /var/lib/mpd \
    && chown -R ${user} /var/log/mpd

# Declare a music , playlists and database volume (state, tag_cache and sticker.sql)
VOLUME ["/var/lib/mpd/music", "/var/lib/mpd/playlists", "/var/lib/mpd/database"]
COPY mpd.conf /etc/mpd.conf
COPY pulse-client.conf /etc/pulse/client.conf
RUN sed -i "s/USERID/${userid}/;" /etc/pulse/client.conf

USER ${user}
RUN mkdir -p /home/mpd/.config/mpd
COPY mpd.conf /home/mpd/.config/mpd/mpd.conf

# Entry point for mpc update and stuff
EXPOSE 6600


CMD ["mpd", "--stdout", "--no-daemon"]
