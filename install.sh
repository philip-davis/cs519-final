#!/bin/bash -e

INSTALL_DIR=${PWD}/install
ADIOS2_DIR=${INSTALL_DIR}/adios2
PRELOAD_DIR=$INSTALL_DIR}/adios2.preload
LIBFABRIC_DIR=${INSTALL_DIR}/libfabric

CC=mpicc
CXX=mpic++
FC=mpifort

if [ ! -d ${INSTALL_DIR} ] ; then
     mkdir ${LIBFABRIC_DIR}
fi

#wget https://github.com/ofiwg/libfabric/releases/download/v1.6.2/libfabric-1.6.2.tar.gz
#tar -xvzf libfabric-1.6.2.tar.gz
#cd libfabric-1.6.2
#./configure --prefix=${LIBFABRIC_DIR} --disable-usnic --disable-verbs CC=${CC}
#make clean
#make
#make install
#cd ..

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${LIBFABRIC_DIR}/lib/pkgconfig

if [ ! -d ${ADIOS2_DIR} ] ; then
    mkdir ${ADIOS2_DIR}
fi

cd ADIOS2
if [ ! -d build ] ; then
    mkdir build
fi
cd build
rm -f CMakeCache.txt
cmake .. -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_Fortran_COMPILER=${FC} -DCMAKE_INSTALL_PREFIX=${ADIOS2_DIR} -DADIOS2_USE_HDF5=Off
make
make install

cd ../..
cd ADIOS2.preload
if [ ! -d build ] ; then
    mkdir build
fi
cd build
rm -f CMakeCache.txt
cmake .. -DCMAKE_C_COMPILER=${CC} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_Fortran_COMPILER=${FC} -DCMAKE_INSTALL_PREFIX=${PRELOAD_DIR} -DADIOS2_USE_HDF5=Off
make
make install
