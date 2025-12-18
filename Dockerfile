FROM --platform=linux/amd64 debian:stable

RUN apt-get update && apt-get install -y \
    nasm \
    gcc \
    gdb \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code
