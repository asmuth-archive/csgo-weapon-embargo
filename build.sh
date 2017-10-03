#!/bin/bash
set -ue

: ${CC:=gcc}
: ${SONAME:=weaponrestrictplugin}
: ${WORKDIR:=.}

SOURCES=plugin.cc

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

# checkout hl2sdk
HL2SDK_GIT="https://github.com/alliedmodders/hl2sdk"
if [[ ! -d "${WORKDIR}/hl2sdk/.git" ]]; then
  git clone "${HL2SDK_GIT}" "${WORKDIR}/hl2sdk" -b csgo
fi

# build plugin
${CC} \
    -D_LINUX \
    -DPOSIX \
    -DGNUC \
    -DCOMPILER_GCC \
    -Wall \
    -Werror \
    -O3 \
    -m32 \
    -std=c++11 \
    -mtune=i486 \
    -march=pentium3 \
    -mmmx \
    -msse \
    -funroll-loops \
    -pipe \
    -fno-strict-aliasing \
    -Wno-overlioaded-virtual \
    -Wno-switch \
    -Wno-unused \
    -Wno-non-virtual-dtor \
    -fno-exceptions \
    -fvisibility=hidden \
    -fvisibility-inlines-hidden \
    -I"${WORKDIR}" \
    -I"${WORKDIR}/hl2sdk/public" \
    -I"${WORKDIR}/hl2sdk/public" \
    -I"${WORKDIR}/hl2sdk/public/engine" \
    -I"${WORKDIR}/hl2sdk/public/tier0" \
    -I"${WORKDIR}/hl2sdk/public/tier1" \
    -I"${WORKDIR}/hl2sdk/public/vstdlib" \
    -I"${WORKDIR}/hl2sdk/public/game/server" \
    -I"${WORKDIR}/hl2sdk/public/game/shared" \
    -I"${WORKDIR}/hl2sdk/public/game/shared/csgo/protobuf" \
    -I"${WORKDIR}/hl2sdk/public/engine/protobuf" \
    -I"${WORKDIR}/hl2sdk/common/protobuf-2.5.0/src" \
    ${SOURCES} \
    -lm \
    -ldl \
    -lstdc++ \
    -shared \
    -static-libgcc \
    "${CSGODIR}/bin/libtier0.so" \
    "${CSGODIR}/bin/libvstdlib.so" \
    "${WORKDIR}/hl2sdk/lib/linux/tier1_i486.a" \
    "${WORKDIR}/hl2sdk/lib/linux/interfaces_i486.a" \
    "${WORKDIR}/hl2sdk/lib/linux/mathlib_i486.a" \
    "${WORKDIR}/hl2sdk/lib/linux32/release/libprotobuf.a" \
    -o "${WORKDIR}/${SONAME}.so"

# install plugin
mkdir -p "${CSGODIR}/csgo/addons"

(cat > "${CSGODIR}/csgo/addons/${SONAME}.vdf") <<EOF
"Plugin"
{
	"file"	"addons/${SONAME}.so"
}
EOF

cp "${WORKDIR}/${SONAME}.so" "${CSGODIR}/csgo/addons"

