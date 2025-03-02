#!/bin/bash
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  cmake -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX}
else
  cmake ${CMAKE_ARGS} -B build --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=${PREFIX}
fi
ninja -C build install
