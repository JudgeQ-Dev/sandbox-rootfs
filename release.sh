#! /bin/bash -e

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# if ! zstd -h >/dev/null 2>&1; then
#     apt install zstd
# fi

TARGET_PATH="${TOP_DIR}/rootfs-packages"

rm -rf "${TARGET_PATH}"
mkdor "${TARGET_PATH}"

for DIR in "${TOP_DIR}"/rootfs/*; do
    if [[ ! -d "${DIR}" ]]; then
        continue
    fi

    DIR_NAME=$(basename "${DIR}")

    tar --use-compress-program=zstd -cvf "${TARGET_PATH}/rootfs_${DIR_NAME}".tar.zst "${DIR}"
done
