#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

if [ "$#" -ne 1 ]; then
    echo "Usage $0 <target>"
    exit 1
fi

TARGET="${1}"
IMAGE_NAME="${TARGET}-build"
# shellcheck disable=SC2001
RUNNER_NAME=$(echo "${TARGET}" | sed 's/[^a-zA-Z0-9\-_]/-/g')

echo "${TARGET}"

# Build the builder
docker build \
    --build-arg TARGET="${TARGET}" \
    -t "${IMAGE_NAME}" \
    -f docker.build/Dockerfile .

# Build chroot
docker rm -f "${RUNNER_NAME}" >/dev/null 2>&1 || true

docker run \
    --privileged \
    --cap-add=sys_admin \
    --name="${RUNNER_NAME}" \
    "${IMAGE_NAME}"

docker cp "${RUNNER_NAME}:/root/rootfs-packages/*" "${TOP_DIR}"/rootfs-packages
docker rm -f "${RUNNER_NAME}"
docker rmi "${IMAGE_NAME}-build"
