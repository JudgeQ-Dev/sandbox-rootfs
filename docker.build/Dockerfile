ARG BASE_IMAGE="ubuntu:22.04"
ARG TARGET="ubuntu20.04"

FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="JudgeQ team <team@judgeq.com>"

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages for build of sandbox-rootfs
RUN apt update &&
    apt install --no-install-recommends --no-install-suggests -y \
        git \
        zip \
        unzip \
        zstd \
        lsb-release \
        debootstrap \
        sudo \
        ca-certificates \
        gnupg2 \
        arch-install-scripts debootstrap \
        binfmt-support qemu qemu-user-static &&
    cp ./${TARGET}/env.sh ./env.sh &&
    cp ./docker.build/docker_entry.sh ./docker_entry.sh

ENTRYPOINT ["/root/docker_entry.sh"]

CMD ["primary"]
