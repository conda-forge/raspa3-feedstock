#!/bin/bash
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
  cmake -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
else
  if [[ "${target_platform}" == "linux"* ]]; then
    export OPENBLAS_USES_OPENMP=1
    ldd $PREFIX/lib/libopenblas.so
    ldd $PREFIX/lib/libblas.so
    ls -lagh $PREFIX/lib/*blas*
    ls -lagh $PREFIX/lib/*lapack*
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBUILD_TESTING=OFF
  fi
  if [[ "${target_platform}" == osx-* ]]; then
    cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_OSX_ARCHITECTURES="arm64" -DBUILD_TESTING=OFF
  fi
fi
ninja -C build install -v
