
mkdir build
cd build

cmake -G "Ninja"              ^
    -DCMAKE_BUILD_TYPE=Release              ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DWITH_LAPACK=libopenblas               ^
    -DLAPACK_DIR=%LIBRARY_PREFIX%           ^
    ..

if errorlevel 1 exit 1

cmake --build . --target install

if errorlevel 1 exit 1
