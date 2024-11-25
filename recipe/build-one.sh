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
  -DBLA_VENDOR="Generic" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF \
  ${CMAKE_ARGS}
cmake --build build --parallel "${CPU_COUNT:-1}"
cmake --install build --verbose

# verify subpackage versions
if [[ "${PKG_NAME}" == lib* ]]; then
  if [[ "$target_platform" == osx-* ]]; then
    test -f ${PREFIX}/lib/${PKG_NAME}.${PKG_VERSION}${SHLIB_EXT}
  else
    test -f ${PREFIX}/lib/${PKG_NAME}${SHLIB_EXT}.${PKG_VERSION}
  fi
fi
