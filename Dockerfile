FROM ubuntu:14.04

MAINTAINER firemilesxu@gmail.com firemiles 

# ---
# crosstool-NG
#  see https://github.com/crosstool-ng/crosstool-ng.git
# ---

RUN \
 apt-get update && \
 apt-get dist-upgrade -y && \
 apt-get install -y git autoconf build-essential gperf bison flex texinfo libtool libncurses5-dev wget gawk libc6-dev help2man unzip libtool && \
 apt-get clean

RUN \
 mkdir /home/firemiles && \
 groupadd -r firemiles -g 433  && \
 useradd -u 431 -r -g firemiles -d /home/firemiles -s /sbin/nologin -c "Docker image user" firemiles  && \
 chown -R firemiles:firemiles /home/firemiles && \
 adduser firemiles sudo && \
 echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/firemiles
USER firemiles

RUN git clone -b 1.22 https://github.com/crosstool-ng/crosstool-ng.git 

WORKDIR /home/firemiles/crosstool-ng

RUN \
 ./bootstrap && ./configure && make && sudo make install && rm -rf ../crosstool-ng/ 

WORKDIR /home/firemiles
VOLUME ["/home/firemiles"]

# work like command
ENTRYPOINT ["ct-ng"]

