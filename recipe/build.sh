#!/bin/bash

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ "${target_platform}" == linux* ]]; then
    cmake -B build --preset=linux_conda_raspa3 
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3
  fi
else
  if [[ "${target_platform}" == linux* ]]; then
    cmake -B build ${CMAKE_ARGS} --preset=linux_conda_raspa3
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake -B build ${CMAKE_ARGS} --preset=mac_conda_raspa3
  fi
fi

ninja -C build install -v
