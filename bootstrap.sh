#! /bin/bash

# binfmt-support qemu qemu-user-static debootstrap arch-install-scripts

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

INSTALL_SCRIPT="install.sh"

cd "${TOP_DIR}"

set -e

if [[ "${UID}" != "0" ]]; then
    echo This script must be run with root privileges.
    exit 1
fi

if ! arch-chroot -h >/dev/null 2>&1; then
    echo "You need arch-chroot to run this script."
    echo "Usually it's in the package "'"'"arch-install-scripts"'".'
    exit 1
fi

if ! debootstrap --version >/dev/null 2>&1; then
    echo "You need debootstrap to run this script."
    exit 1
fi

if [[ "${ROOTFS_PATH}" == "" ]]; then
    echo "Please specify the path to put rootfs on with ROOTFS_PATH."
    exit 1
fi

# if [[ "$MIRROR" == "" ]]; then
#     MIRROR="http://mirrors.tuna.tsinghua.edu.cn/ubuntu"
# fi

if [[ -z "${ARCH}" ]]; then
    ARCH="amd64"
fi

if [[ -z "${DEBIAN_TAG}" ]]; then
    DEBIAN_TAG="focal"
fi

rm -rf "${ROOTFS_PATH}"
mkdir -p "${ROOTFS_PATH}"

debootstrap --arch="${ARCH}" --foreign --components=main,universe "${DEBIAN_TAG}" "${ROOTFS_PATH}" "${MIRROR}"

QEMU_ARCH=""

if [[ "${ARCH}" == "amd64" ]]; then
    QEMU_ARCH="x86_64"
elif [[ "${ARCH}" == "arm64" ]]; then
    QEMU_ARCH="aarch64"
else
    QEMU_ARCH="${ARCH}"
fi

cp "$(which qemu-"${QEMU_ARCH}"-static)" "${ROOTFS_PATH}"/usr/bin/
arch-chroot "${ROOTFS_PATH}" /debootstrap/debootstrap --second-stage

cp "${INSTALL_SCRIPT}" "${ROOTFS_PATH}/root"
arch-chroot "${ROOTFS_PATH}" "/root/${INSTALL_SCRIPT}"

rm "${ROOTFS_PATH}/root/${INSTALL_SCRIPT}"
