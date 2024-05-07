#!/bin/bash


# conda compilers strip links that aren't used by default,
# even if explicitly given.
# This may result in undefined symbols
# when libraries are intended to bundle others they may
# not use themselves (e.g. umfpack bundling cholmod-Wl,-dead_strip_dylibs)
export LDFLAGS=${LDFLAGS/-Wl,--as-needed/}
export LDFLAGS=${LDFLAGS/-Wl,-dead_strip_dylibs/}

if [[ "${target_platform}" != "${build_platform}" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CROSSCOMPILING=ON"
fi

# add
# can add lagraph and -DSUITESPARSE_USE_SYSTEM_GRAPHBLAS after packaging 9.1
cmake -B build -LAH \
  -DSUITESPARSE_USE_CUDA=OFF \
  -DGRAPHBLAS_COMPACT=ON \
  -DBLA_VENDOR="Generic" \
  -DBLAS_LIBRARIES="$PREFIX/lib/libblas${SHLIB_EXT};$PREFIX/lib/libcblas${SHLIB_EXT}" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF \
  ${CMAKE_ARGS}
cmake --build build --parallel "${CPU_COUNT:-1}" --verbose
cmake --install build --verbose
