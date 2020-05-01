#!/bin/bash

ROOT_DIR=`pwd`/..
INSTALLED_NAME=$1

./configure CC=gcc FC=gfortran CXX=g++ --prefix=${ROOT_DIR}/installed/${INSTALLED_NAME} --with-device=ch4:ofi --with-libfabric=embedded --enable-ch4-netmod-inline=no --enable-ch4-shm-inline=no --with-pip-prefix=${ROOT_DIR}/lib/pip --with-ch4-shmmods=pip && make -j 8 && make install


