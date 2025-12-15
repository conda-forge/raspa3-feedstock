#!/bin/bash

rm -rf .git
rm -rf /usr/lib/jvm
rm -rf /usr/share/dotnet
rm -rf /usr/share/swift
rm -rf /usr/local/.ghcup
rm -rf /usr/local/julia*
rm -rf /usr/local/lib/android
rm -rf /usr/local/share/chromium
rm -rf /opt/google
rm -rf /usr/local/share/powershell

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ "${target_platform}" == linux* ]]; then
    cmake -B build --preset=linux_conda_raspa3_gcc -DCMAKE_POLICY_VERSION_MINIMUM=3.32
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 -DCMAKE_POLICY_VERSION_MINIMUM=3.32
  fi
else
  if [[ "${target_platform}" == linux-aarch64 ]]; then 
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=true -DBUILD_CLI=false -DBUILD_TESTING=false
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=true -DBUILD_CLI=false -DBUILD_TESTING=false
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32
  fi
fi

ninja -C build install -v -j1

# second stage for linux cross-compilation
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" == "1" ]]; then
  if [[ "${target_platform}" == linux-aarch64 ]]; then 
    rm -rf build
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=false -DBUILD_CLI=true -DBUILD_TESTING=false
    ninja -C build install -v -j1
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    rm -rf build
    cmake -B build --preset=linux_conda_raspa3_gcc ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DBUILD_APP=false -DBUILD_CLI=true -DBUILD_TESTING=false
    ninja -C build install -v -j1
  fi
fi
