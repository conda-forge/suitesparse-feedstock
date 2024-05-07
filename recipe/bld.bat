cmake -G "Ninja" -LAH ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DBUILD_STATIC_LIBS=OFF ^
    -DSUITESPARSE_DEMOS=OFF ^
    -DBUILD_TESTING=OFF ^
    -DBLA_VENDOR=Generic ^
    -DGRAPHBLAS_COMPACT=ON ^
    -B build .
if errorlevel 1 exit 1

cmake --build build --config Release --target install
if errorlevel 1 exit 1
