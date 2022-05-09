#! /bin/bash -e

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

BOOTSTRAP_SCRIPT="${TOP_DIR}/bootstrap.sh"
ROOTFS_ROOT_PATH="${TOP_DIR}/rootfs"

ARCH_LIST="
amd64 \
"

for arch in ${ARCH_LIST}; do
    export ARCH="${arch}"
    export ROOTFS_PATH="${ROOTFS_ROOT_PATH}/${DEBIAN_LONG_VERSION}_${ARCH}"
    bash "${BOOTSTRAP_SCRIPT}"
done
