#!/bin/bash

ROOT_DIR=`pwd`

# retrive modules
git submodule update --init --recursive

# Patched Glibc
cd ${ROOT_DIR}/deps/glibc && mkdir build 
cp build.sh build && \
cd build && ./build.sh ${ROOT_DIR}/deps/glibc ${ROOT_DIR}/lib/glibc 2>&1 | tee build.log

stat=$?
if [ $stat -ne 0 ]; then
    echo "compile glibc fails"
    exit 1
fi

# PiP
cd ${ROOT_DIR}/deps/PiP && \
gcc_version=`gcc -v 2>&1 | grep "gcc version" | awk '{print $3}'` && \
if [ "${gcc_version}" != "4.8.5" ]; then
    echo "please use gcc 4.8.5 version for pip compilation"
    exit 1
fi

sh install.sh ${ROOT_DIR}/lib/pip ${ROOT_DIR}/lib/glibc 2>&1 | tee install.log && \
cd ${ROOT_DIR}/lib/pip/bin && ./piplnlibs

stat=$?
if [ $stat -ne 0 ]; then
    echo "compile pip fails"
    exit 1
fi


# Benchmark branch compile
cd ${ROOT_DIR}/cab-mpi

# install standard MPICH
git checkout pmodel-master
./autogen.sh | tee autogen.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "autogen fails - please check autotools configuration"
fi

INSTALLED_NAME=mpich-std
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

git checkout rebase-pip-pingpong-original
./autogen.sh | tee autogen.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "autogen fails - please check autotools configuration"
fi

# pingpong original broadwell
INSTALLED_NAME=mpich-pingpong-original-bdw
export MPICHLIB_CFLAGS="-DBEBOP -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "original mpich (bdw) compilation fails"
fi

# pingpong original KNL
INSTALLED_NAME=mpich-pingpong-original-knl
export MPICHLIB_CFLAGS="-DKNL -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "original mpich (knl) compilation fails"
fi

# pingpong localized broadwell
git checkout rebase-pip-pingpong-localized
INSTALLED_NAME=mpich-pingpong-localized-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "localized mpich (bdw) compilation fails"
fi

# pingpong localized knl
INSTALLED_NAME=mpich-pingpong-localized-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "localized mpich (knl) compilation fails"
fi

# pingpong mixed broadwell
git checkout rebase-pip-pingpong-mixed
INSTALLED_NAME=mpich-pingpong-mixed-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "mixed mpich (bdw) compilation fails"
fi

# pingpong mixed knl
INSTALLED_NAME=mpich-pingpong-mixed-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "mixed mpich (knl) compilation fails"
fi


#pingpong throughput bdw
git checkout rebase-pip-pingpong-throughput
INSTALLED_NAME=mpich-pingpong-throughput-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (bdw) compilation fails"
fi

# pingpong throughput knl
INSTALLED_NAME=mpich-pingpong-throughput-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (knl) compilation fails"
fi

# Opt branch compile
# throughput-aware bdw
git checkout rebase-pip-throughput-aware
INSTALLED_NAME=mpich-throughput-aware-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (bdw) compilation fails"
fi

# throughput-aware knl
INSTALLED_NAME=mpich-throughput-aware-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (knl) compilation fails"
fi