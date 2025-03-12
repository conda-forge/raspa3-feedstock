#!/bin/bash
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  if [[ "${target_platform}" == "linux"* ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset mac_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  fi
else
  if [[ "${target_platform}" == "linux"* ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset mac_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF -DCMAKE_OSX_ARCHITECTURES="arm64"
  fi
fi
ninja -C build install -v
