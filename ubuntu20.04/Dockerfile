FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY ./rootfs-packages /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-256color

RUN apt update \
    && apt install --no-install-recommends --no-install-suggests -y \
        arch-install-scripts \
        zstd \
    && ls \
    && ARCH=$(dpkg --print-architecture) \
    && TARGET_NAME="ubuntu20.04_${ARCH}" \
    && TARGET="${TARGET_NAME}.tar.zst" \
    && tar --use-compress-program=unzstd -xvf /root/rootfs-packages/${TARGET} -C / \
    && rm -rf /root/*

CMD ["/bin/bash"]
