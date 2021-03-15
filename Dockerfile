# Base images
FROM ubuntu:20.04

# MAINTAINER 维护者信息
MAINTAINER BICBT

# ENV 设置环境变量
ENV DEBIAN_FRONTEND noninteractive

# Install tools & dependencies
RUN apt-get update && \
    apt-get install -y wget \
        tclsh           \
        pkg-config      \
        cmake           \
        libssl-dev      \
        unzip           \
        build-essential \
        libz-dev

# Download and Install Haivision SRT
RUN cd /tmp && \
    wget -O haivision-srt.zip https://github.com/Haivision/srt/archive/master.zip && \
    unzip haivision-srt.zip && \
    mv srt-master /usr/local/haivision-srt && \
    cd /usr/local/haivision-srt && \
    ./configure && \
    make && make install && \
    rm -rf /tmp/haivision-srt.zip && \
    ldconfig

# Download and Install SRT-LIVE-SERVER
RUN cd /tmp && \
    wget -O srt-live-server.zip https://github.com/BICBT/srt-live-server/archive/master.zip && \
    unzip srt-live-server.zip && \
    mv srt-live-server-master /usr/local/srt-live-server && \
    cd /usr/local/srt-live-server && \
    make && \
    rm -rf /tmp/srt-live-server.zip

# Set WORKDIR
WORKDIR /usr/local/srt-live-server

# Setup Config File
COPY sls.conf sls.conf

# EXPOSE PORT
EXPOSE 8080

#CMD
CMD ["./bin/sls", "-c", "sls.conf"]
