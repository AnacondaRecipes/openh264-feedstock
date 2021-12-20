#!/bin/bash -e

set -x

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == 1 ]]; then
  if [[ "$ARCH" == "64" ]]; then
    ARCH=x86_64
  fi
  sed -i.bak "s/ARCH=.*/ARCH=$ARCH/g" Makefile
fi

make PREFIX=$PREFIX -j${CPU_COUNT}
make PREFIX=$PREFIX install

mkdir -p -m755 -v "$PREFIX"/bin
install -m755 -v h264dec "$PREFIX"/bin/h264dec
install -m755 -v h264enc "$PREFIX"/bin/h264enc

if [[ ${target_platform} =~ .*osx.* ]]; then
    ln -s "${PREFIX}/lib/libopenh264.6${SHLIB_EXT}" \
        "${PREFIX}/lib/libopenh264.5${SHLIB_EXT}"
elif [[ ${target_platform} =~ .*linux.* ]]; then 
    ln -s "${PREFIX}/lib/libopenh264${SHLIB_EXT}.6" \
        "${PREFIX}/lib/libopenh264${SHLIB_EXT}.5"
fi
