#!/bin/bash
set -eux
# common build script for all subpackages

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

if [[ -z "${FC:-}" || ! -f "${FC:-fc_compiler}" ]]; then
  echo "Not using fortran"
  export CMAKE_ARGS="${CMAKE_ARGS} -DSUITESPARSE_USE_FORTRAN=OFF"
fi

cd "${SUBPKG_DIR}"

cmake -B build \
  -G Ninja \
  -DBLA_VENDOR="Generic" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF \
  ${CMAKE_ARGS}

# verify subpackage version, since it doesn't get updated automatically
# line in CMakeCache looks like:
# //Value Computed by CMake
# CMAKE_PROJECT_VERSION:STATIC=3.3.3

PROJECT_VERSION=$(grep "CMAKE_PROJECT_VERSION:" build/CMakeCache.txt | cut -d= -f2)
if [[ "${PROJECT_VERSION}" != "${PKG_VERSION}" ]]; then
  echo "CMake Project version ${PROJECT_VERSION} != conda package version ${PKG_VERSION}, update package version for ${PKG_NAME}=${PROJECT_VERSION}"
  exit 1
fi

cmake --build build --parallel "${CPU_COUNT:-1}"
cmake --install build --verbose
