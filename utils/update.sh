#!/bin/bash

set -o nounset
set -o errexit


BATS_LATEST=https://api.github.com/repos/bats-core/bats-core/releases/latest
BATS_SUPPORT_LATEST=https://api.github.com/repos/bats-core/bats-support/releases/latest
BATS_ASSERT_LATEST=https://api.github.com/repos/bats-core/bats-assert/releases/latest
OUTDIR=$(realpath "$(dirname "$0")/..")/bats_core_pkg
DISTDIR=$OUTDIR/dist


get_latest() {
    local latest_url=${1?}
    local outdir=${2?}
    local tmpdir
    local tar_url
    tar_url=$(
        curl -s "$latest_url" \
        | jq -r '.tarball_url'
    )
    tmpdir="$(mktemp -d)"

    echo "Downloading the latest version to $outdir ($tar_url)"
    cd "$tmpdir"

    curl -s --location "$tar_url" \
        | tar xzf -

    mv "$tmpdir"/* "$outdir/"
    rm -rf "$tmpdir"

}


get_bats() {
    local latest_url="${1?}"
    local outdir="${2?}"
    local tmpdir
    tmpdir="$(mktemp -d)"

    get_latest "$latest_url" "$tmpdir"

    # shellcheck disable=SC2211
    "$tmpdir"/bats-core-bats-core-*/install.sh "$outdir"
    mv "$tmpdir"/bats-core-bats-core-*/AUTHORS "$tmpdir"/bats-core-bats-core-*/LICENSE.md "$outdir/"
    rm -rf "$tmpdir"
}


get_bats_helper() {
    local latest_url="${1?}"
    local outdir="${2?}"
    local tmpdir
    tmpdir="$(mktemp -d)"
    mkdir -p "$outdir"

    get_latest "$latest_url" "$tmpdir"
    # shellcheck disable=SC2211
    mv "$tmpdir"/bats-core-*/* "$outdir/"
    rm -rf "$tmpdir"
}


main() {
    rm -rf bats_core_pkg/dist
    get_bats "$BATS_LATEST" "$DISTDIR"
    get_bats_helper "$BATS_SUPPORT_LATEST" "$DISTDIR/test_helper/bats-support"
    get_bats_helper "$BATS_ASSERT_LATEST" "$DISTDIR/test_helper/bats-assert"
}


main "$@"
