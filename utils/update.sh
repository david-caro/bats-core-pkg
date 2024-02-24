#!/bin/bash

set -o nounset
set -o errexit


BATS_LATEST=https://api.github.com/repos/bats-core/bats-core/releases/latest
OUTDIR=$(realpath $(dirname $0)/..)/bats_core_pkg

main() {
    local tar_url=$(
        curl -s "$BATS_LATEST" \
        | jq -r '.tarball_url'
    )

    echo "Downloading the latest bats version to $OUTDIR ($tar_url)"
    cd "$OUTDIR"

    curl --location "$tar_url" \
        | tar xvzf -

    bats-core-bats-core-*/install.sh $PWD/dist
    mv bats-core-bats-core-*/AUTHORS bats-core-bats-core-*/LICENSE.md dist/
    rm -rf bats-core-bats-core-*
}



main "$@"
