# Base images
FROM ubuntu:20.04

# MAINTAINER 维护者信息
MAINTAINER BICBT

# ENV 设置环境变量

# Install tools & dependencies
RUN sudo apt-get update &&                  \
    sudo apt-get upgrade &&                 \
    sudo apt-get install    tclsh           \    
                            pkg-config      \
                            cmake           \
                            libssl-dev      \
                            unzip           \
                            build-essential 

# Download and Install Haivision SRT
RUN mkdir -p /usr/local/haivision-srt && \
    cd /usr/local/haivision-srt && \
    wget -O haivision-srt.zip https://github.com/Haivision/srt/archive/master.zip && \
    unzip haivision-srt.zip && \
    cd haivision-srt && \
    ./configure && \
    make && make install && \
    rm -rf /usr/local/haivision-srt.zip

# Download and Install SRT-LIVE-SERVER
RUN mkdir -p /usr/local/srt-live-server && \
    cd /usr/local/srt-live-server && \
    wget -O srt-live-server.zip https://github.com/BICBT/srt-live-server/archive/master.zip && \
    unzip srt-live-server.zip && \
    cd srt-live-server && \
    sudo make && make install && \
    rm -rf /usr/local/srt-live-server.zip

# Setup Config File
COPY sls.conf /usr/local/srt-live-server/sls.conf

# Set WORKDIR
WORKDIR /usr/local/srt-live-server

# EXPOSE PORT
EXPOSE 8080

#CMD
CMD ["./bin/sls", "-c", "sls.conf"]
