FROM ubuntu:18.04
MAINTAINER @BenjaminHae https://github.com/BenjaminHae

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -q --yes --no-install-recommends \
    git cmake libmpdclient gcc g++ libmpdclient-dev openssl-dev make

RUN git clone https://github.com/notandy/ympd.git /tmp/ympd
    
WORKDIR /tmp/ymp

RUN cmake .. -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ -DCMAKE_INSTALL_PREFIX:PATH=/usr \
 && make \
 && make-install

RUN DEBIAN_FRONTEND=noninteractive apt-get remove -q --yes \
 && git cmake gcc g++ libmpdclient-dev openssl-dev make\
 && apt-get autoremove \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Entry point for mpc update and stuff
EXPOSE 8080


CMD ["ympd", "-h", "mpd", "-p", "6600", "-w", "8080"]
