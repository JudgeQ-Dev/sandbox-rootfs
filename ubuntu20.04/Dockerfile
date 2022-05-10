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
    && ARCH=$(dpkg --print-architecture) \
    && ORIGIN_NAME="sandbox-rootfs_ubuntu20.04_${ARCH}" \
    && ORIGIN="${ORIGIN_NAME}.tar.zst" \
    && TARGET="sandbox-rootfs.tar.zst" \
    $$ mv "${ORIGIN}" "${TARGET}" \
    && rm -rf $(ls /root | grep -v "${TARGET}") \
    && echo "tar --use-compress-program=unzstd -xvf /root/${TARGET} -C /" >> /root/init.sh \
    && chmod +x /root/init.sh

CMD ["/bin/bash"]
