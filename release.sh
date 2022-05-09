#! /bin/bash -e

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if ! zstd -h >/dev/null 2>&1; then
    apt install zstd
fi

for DIR in "${TOP_DIR}"/install/*; do
    if [[ ! -d "${DIR}" ]]; then
        continue
    fi

    DIR_NAME=$(basename "${DIR}")

    tar --use-compress-program=zstd -cvf sandbox-rootfs_"${DIR_NAME}".tar.zst "${DIR}"
done
