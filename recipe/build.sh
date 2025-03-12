#!/bin/bash
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  if [[ "${target_platform}" == linux-64 ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF -DFINAL_CXXFLAGS="--target=ppc64le ${FINAL_CXXFLAGS}"
  elif [[ "${target_platform}" == linux-aarch64 ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF -DFINAL_CXXFLAGS="--target=aarch64 ${FINAL_CXXFLAGS}"
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset mac_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  fi
else
  if [[ "${target_platform}" == "linux"* ]]; then
    cmake -B build --preset linux_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset mac_conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF -DCMAKE_OSX_ARCHITECTURES="arm64"
  fi
fi
ninja -C build install -v
