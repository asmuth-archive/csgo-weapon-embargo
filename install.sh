#!/bin/bash
set -ue

: ${SONAME:=weaponrestrictplugin}
: ${WORKDIR:=.}

# locate csgo dedicated server
if [[ ! $# -eq 1 ]]; then
  echo "usage: $0 path/to/csgo" >&2
  exit 1
fi

CSGODIR="$1"

if [[ ! -e "${CSGODIR}/steamapps/appmanifest_740.acf" ]]; then
  echo "ERROR: csgo dedicated server not found at '${CSGODIR}'" >&2
  exit 1
fi

# locate plugin
if [[ ! -e "${WORKDIR}/${SONAME}.so" ]]; then
  echo "ERROR: plugin not found at '${WORKDIR}/${SONAME}.so'; did you run build.sh?" >&2
  exit 1
fi

# install plugin
mkdir -p "${CSGODIR}/csgo/addons"
cp "${WORKDIR}/${SONAME}.so" "${CSGODIR}/csgo/addons"
