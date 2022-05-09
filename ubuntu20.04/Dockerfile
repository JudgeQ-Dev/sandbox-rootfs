FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY ./rootfs /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM xterm-256color

RUN mv "/root/rootfs/ubuntu20.04_$(dpkg --print-architecture)" /rootfs

CMD ["/bin/bash"]
