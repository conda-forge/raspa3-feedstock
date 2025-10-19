#!/bin/bash

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  if [[ "${target_platform}" == linux* ]]; then
    cmake -B build --preset=linux_conda_raspa3 -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DCMAKE_C_COMPILER=${CC_FOR_BUILD} -DCMAKE_CXX_COMPILER=${CXX_FOR_BUILD}
  elif [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DCMAKE_C_COMPILER=${CC_FOR_BUILD} -DCMAKE_CXX_COMPILER=${CXX_FOR_BUILD}
  fi
else
  if [[ "${target_platform}" == linux-aarch64 ]]; then 
    cmake -B build --preset=linux_conda_raspa3 ${CMAKE_ARGS}  -DCMAKE_CXX_COMPILER_AR="$BUILD_PREFIX/bin/aarch64-conda-linux-gnu-ar" -DCMAKE_CXX_COMPILER_RANLIB="$BUILD_PREFIX/bin/aarch64-conda-linux-gnu-ranlib" -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DCMAKE_C_COMPILER=${CC_FOR_BUILD} -DCMAKE_CXX_COMPILER=${CXX_FOR_BUILD}
  elif [[ "${target_platform}" == linux-ppc64le ]]; then
    cmake -B build --preset=linux_conda_raspa3 ${CMAKE_ARGS} -DCMAKE_CXX_COMPILER_AR="$BUILD_PREFIX/bin/powerpc64le-conda-linux-gnu-ar" -DCMAKE_CXX_COMPILER_RANLIB="$BUILD_PREFIX/bin/powerpc64le-conda-linux-gnu-ranlib" -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DCMAKE_C_COMPILER=${CC_FOR_BUILD} -DCMAKE_CXX_COMPILER=${CXX_FOR_BUILD}
  elif  [[ "${target_platform}" == osx-* ]]; then
    cmake -B build --preset=mac_conda_raspa3 ${CMAKE_ARGS} -DCMAKE_POLICY_VERSION_MINIMUM=3.32 -DCMAKE_C_COMPILER=${CC_FOR_BUILD} -DCMAKE_CXX_COMPILER=${CXX_FOR_BUILD}
  fi
fi

ninja -C build install -v
