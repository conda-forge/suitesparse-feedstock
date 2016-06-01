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

# build METIS first, installing into $PREFIX rather than the source DIR
cd metis-5.1.0
make config shared=1 prefix=${PREFIX}
make
make install

if [ "$(uname)" == "Darwin" ]
then
    # this is copied from the SuiteSparse Makefile
    install_name_tool -id ${PREFIX}/lib/libmetis.dylib ${PREFIX}/lib/libmetis.dylib
fi

# also build static version of METIS
make config prefix=${PREFIX}
make
make install
cd ..

# export environment variable so SuiteSparse will use the METIS built above
export MY_METIS_LIB="-L${PREFIX}/lib -lmetis"

# (optional) write out various make variables for easier build debugging
eval ${LIBRARY_SEARCH_VAR}="${PREFIX}/lib" make config 2>&1 | tee make_config.txt

# make SuiteSparse
eval ${LIBRARY_SEARCH_VAR}="${PREFIX}/lib" make -j1
make install

if [ "$(uname)" == "Darwin" ]; then
  # change link to METIS for CHOLMOD to reflect install path
  install_name_tool -change $SRC_DIR/lib/libmetis.dylib @rpath/libmetis.dylib $PREFIX/lib/libcholmod.dylib
fi
