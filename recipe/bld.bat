setlocal EnableDelayedExpansion

cmake -B build ^
  -G "Ninja" ^
  -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd;btf;camd;ccolamd;colamd;cholmod;cxsparse;ldl;klu;umfpack;paru;rbio;spqr" ^
  -DBLA_VENDOR=Generic ^
  -DBLAS_LIBRARIES="blas;cblas" ^
  -DLAPACK_LIBRARIES="lapack" ^
  -DBUILD_SHARED_LIBS=ON ^
  -DBUILD_STATIC_LIBS=OFF ^
  -DCMAKE_BUILD_TYPE:STRING=Release ^
  -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
  -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
  -DSUITESPARSE_HAS_FORTRAN:BOOL=ON ^
  -DCMAKE_Fortran_COMPILER=flang.exe ^
  %CMAKE_ARGS%
if errorlevel 1 exit 1

cmake --build build --verbose
if errorlevel 1 exit 1

cmake --install build --verbose
if errorlevel 1 exit 1
