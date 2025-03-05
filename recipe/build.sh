#!/bin/bash
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  cmake -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF -DBLA_SIZEOF_INTEGER="8"
else
  if [[ "${target_platform}" == "linux"* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBLA_SIZEOF_INTEGER="8" -DCMAKE_CXX_FLAGS_RELEASE="-march=armv8-a ${CMAKE_CXX_FLAGS_RELEASE}" -DBUILD_TESTING=OFF
  fi
  if [[ "${target_platform}" == osx-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBLA_SIZEOF_INTEGER="8" -DCMAKE_OSX_ARCHITECTURES="arm64" -DBUILD_TESTING=OFF
  fi
fi
ninja -C build install -v
