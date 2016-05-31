#!/bin/bash

cp -f "${RECIPE_DIR}/SuiteSparse_config.mk" SuiteSparse_config/SuiteSparse_config.mk

if [ "$(uname)" == "Darwin" ]
then
    export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
    DYNAMIC_EXT=".dylib"
else
    export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
    DYNAMIC_EXT=".so"
fi


export INCLUDE_PATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"

export INSTALL_LIB="${PREFIX}/lib"
export INSTALL_INCLUDE="${PREFIX}/include"

export BLAS="-lopenblas"
export LAPACK="-lopenblas"

# (optional) write out various make variables for easier build debugging
eval ${LIBRARY_SEARCH_VAR}="${PREFIX}/lib" make config 2>&1 | tee make_config.txt

eval ${LIBRARY_SEARCH_VAR}="${PREFIX}/lib" make -j1

# make install below fails to link libmetis unless it is copied to $PREFIX/lib
cp $SRC_DIR/lib/libmetis$DYNAMIC_EXT $PREFIX/lib

make install


if [ "$(uname)" == "Darwin" ]; then

  # change link to METIS for CHOLMOD to reflect install path
  install_name_tool -change $SRC_DIR/lib/libmetis.dylib @rpath/libmetis.dylib $PREFIX/lib/libcholmod.dylib

fi
