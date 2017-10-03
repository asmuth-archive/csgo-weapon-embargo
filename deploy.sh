#!/bin/bash
set -ue

: ${CC:=gcc}
: ${SONAME:=weaponrestrictplugin}
: ${WORKDIR:=.}

SOURCES=plugin.cc

# checkout hl2sdk
HL2SDK_GIT="https://github.com/alliedmodders/hl2sdk"
if [[ ! -d "${WORKDIR}/hl2sdk/.git" ]]; then
  git clone "${HL2SDK_GIT}" "${WORKDIR}/hl2sdk"
fi

# build plugin object
${CC} -c \
    -D_LINUX \
    -DPOSIX \
    -DGNUC \
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
    -o "${SONAME}.o"

