#!/bin/bash -eu

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if [ "$#" -ne 1 ]; then
    echo "Usage $0 <target>"
fi

TARGET="${1}"
IMAGE_NAME="${TARGET}-build"
# shellcheck disable=SC2001
RUNNER_NAME=$(echo "${TARGET}" | sed 's/[^a-zA-Z0-9\-_]/-/g')

# Build the builder
docker build -t "${IMAGE_NAME}" -f docker.build/Dockerfile .

# Build chroot
docker rm -f "${RUNNER_NAME}" >/dev/null 2>&1 || true

docker run \
    --privileged \
    --cap-add=sys_admin \
    --name="${RUNNER_NAME}" \
    "${IMAGE_NAME}"

docker cp -a "${RUNNER_NAME}:/rootfs" ./
docker rm -f "${RUNNER_NAME}"
docker rmi "${IMAGE_NAME}-build"

bash "${TOP_DIR}"/release.sh
