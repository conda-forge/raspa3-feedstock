#!/bin/bash

if [[ "$target_platform" == linux-* ]]; then
  # workaround a binutils bug
  export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,$(pwd)/lib"
  export LDFLAGS=$(echo "${LDFLAGS}" | sed "s/-Wl,--as-needed//g")
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  cmake -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX}
else
  if [[ "$target_platform" == linux-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_SYSTEM_PROCESSOR="aarch64"
  fi
  if [[ "$target_platform" == osx-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_OSX_ARCHITECTURES="arm64"
  fi
fi

ninja -C build install -v
