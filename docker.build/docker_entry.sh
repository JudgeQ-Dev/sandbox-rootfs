#! /bin/bash

TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

set -e -x

if [ X"${1}" = X"primary" ]; then
    # shellcheck disable=SC1091
    . "${TOP_DIR}"/env.sh
    bash "${TOP_DIR}"/build.sh
    bash "${TOP_DIR}"/release.sh
else
    exec "${@}"
fi
