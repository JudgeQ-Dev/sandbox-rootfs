#! /bin/bash

set -e -x

if [ X"${1}" = X"primary" ]; then
    # shellcheck disable=SC1091
    . ./env.sh
    bash build.sh
    bash release.sh
else
    exec "${@}"
fi
