#! /bin/bash -e

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if ! zstd -h >/dev/null 2>&1; then
    apt install zstd
fi

cd "${TOP_DIR}" || exit 1

TARGET_PATH="${TOP_DIR}/rootfs-packages"

rm -rf "${TARGET_PATH}"
mkdir "${TARGET_PATH}"

cd "./rootfs" || exit 1

for DIR in "${TOP_DIR}"/rootfs/*; do
    if [[ ! -d "${DIR}" ]]; then
        continue
    fi

    DIR_NAME=$(basename "${DIR}")

    mv "${DIR_NAME}" "rootfs"

    tar --use-compress-program=zstd -cvf "${TARGET_PATH}/rootfs_${DIR_NAME}".tar.zst "./rootfs"

    mv "rootfs" "${DIR_NAME}"
done

cd "${TOP_DIR}" || exit 1
