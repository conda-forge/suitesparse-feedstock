#!/bin/bash


# conda compilers strip links that aren't used by default,
# even if explicitly given.
# This may result in undefined symbols
# when libraries are intended to bundle others they may
# not use themselves (e.g. umfpack bundling cholmod-Wl,-dead_strip_dylibs)
export LDFLAGS=${LDFLAGS/-Wl,--as-needed/}
export LDFLAGS=${LDFLAGS/-Wl,-dead_strip_dylibs/}

export CMAKE_ARGS="${CMAKE_ARGS} -DSUITESPARSE_USE_CUDA=OFF"

if [[ "${target_platform}" != "${build_platform}" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CROSSCOMPILING=ON"
fi

# can add lagraph and -DSUITESPARSE_USE_SYSTEM_GRAPHBLAS after packaging 9.1
cmake -B build \
  -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd;btf;camd;ccolamd;colamd;cholmod;cxsparse;ldl;klu;umfpack;paru;rbio;spqr;spex" \
  -DBLA_VENDOR="Generic" \
  -DBLA_PREFER_PKGCONFIG=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF \
  ${CMAKE_ARGS}
cmake --build build --parallel "${CPU_COUNT:-1}" --verbose
cmake --install build --verbose
