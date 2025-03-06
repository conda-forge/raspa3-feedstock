cmake -B build -G "Ninja Multi-Config" ${CMAKE_ARGS} --preset conda_raspa3 -DCMAKE_INSTALL_PREFIX=%PREFIX% 
if errorlevel 1 exit 1
ninja -C build install
if errorlevel 1 exit 1
