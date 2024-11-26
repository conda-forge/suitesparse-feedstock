#!/bin/bash
set -eux

# conda compilers strip links that aren't used by default,
# even if explicitly given.
# This may result in undefined symbols
# when libraries are intended to bundle others they may
# not use themselves (e.g. umfpack bundling cholmod)
export LDFLAGS=${LDFLAGS/-Wl,--as-needed/}
export LDFLAGS=${LDFLAGS/-Wl,-dead_strip_dylibs/}

export CMAKE_ARGS="${CMAKE_ARGS} -DSUITESPARSE_USE_CUDA=OFF"

if [[ "${target_platform}" != "${build_platform}" ]]; then
  export CMAKE_ARGS="${CMAKE_ARGS} -DCMAKE_CROSSCOMPILING=ON"
fi

# graphblas, lagraph packaged separately
cmake -B build \
  -DSUITESPARSE_ENABLE_PROJECTS="suitesparse_config;amd;btf;camd;ccolamd;colamd;cholmod;cxsparse;ldl;klu;umfpack;paru;rbio;spqr;spex;mongoose" \
  -DBLA_VENDOR="Generic" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF \
  ${CMAKE_ARGS}
cmake --build build --parallel "${CPU_COUNT:-1}"
cmake --install build --verbose
