
rd /s /q %LIBRARY_LIB%\cmake\lapack-3.8.0

mkdir build
cd build

cmake -G "Ninja"              ^
    -DCMAKE_BUILD_TYPE=Release              ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DBUILD_SHARED_LIBS=ON ^
    -DBUILD_METIS=OFF ^
    ..

if errorlevel 1 exit 1

cmake --build . --target install

if errorlevel 1 exit 1
