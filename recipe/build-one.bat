setlocal EnableDelayedExpansion

if "%FC%" NEQ "" (
  echo using fortran %FC%
  set "CMAKE_ARGS=!CMAKE_ARGS! -DSUITESPARSE_HAS_FORTRAN:BOOL=ON"
) else (
  echo no fortran
  set "CMAKE_ARGS=!CMAKE_ARGS! -DSUITESPARSE_HAS_FORTRAN:BOOL=OFF"
)

cd "%SUBPKG_DIR%"
if errorlevel 1 exit 1

cmake -B build ^
  -G "Ninja" ^
  -DBLA_VENDOR=Generic ^
  -DBUILD_SHARED_LIBS=ON ^
  -DBUILD_STATIC_LIBS=OFF ^
  -DCMAKE_BUILD_TYPE:STRING=Release ^
  -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
  !CMAKE_ARGS!

if errorlevel 1 exit 1

cmake --build build --verbose
if errorlevel 1 exit 1

cmake --install build --verbose
if errorlevel 1 exit 1

