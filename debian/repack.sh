#!/bin/bash

set -e

if [ ! -f "$3" ] && [ ! -f "$1" ]; then
    echo "This script must be run manually by specifying the gem file" >&2
    exit 1
fi

gemball=

[ -f "$3" ] && gemball="$3"
[ -z "$gemball" -a -f "$1" ] && gemball="$1"

gemname="$(basename "$gemball")"
fname="${gemname/.gem}.tar.gz"
gemball="$(readlink -f "$gemball")"
tarball="${gemball/.gem}.tar.gz"

#echo "gemball: $gemball"
#echo "gemname: $gemname"
#echo "fname: $fname"
#echo "tarball: $tarball"

tdir="$(mktemp -d)"
#trap '[ ! -d "$tdir" ] || rm -r "$tdir"' EXIT

cd "$tdir"
gem unpack "$gemball"

tar -czf $tdir/${fname} *

mv "$gemball" "$gemball.bkp"
mv "$tdir/$fname" "$tarball"
