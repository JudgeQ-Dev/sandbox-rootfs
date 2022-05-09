FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV INSTALL_DEBOOTSTRAP_DEPS=true
ENV DEBIAN_TAG=focal

RUN bash bootstrap.sh

CMD ["/bin/bash"]
