#!/bin/bash

ROOT_DIR=`pwd`

# retrive modules
git submodule update --init --recursive

# OpenBLAS
cd ${ROOT_DIR}/deps/openblas && \
make && \
make PREFIX=${ROOT_DIR}/lib/openblas install

# PAPI
cd ${ROOT_DIR}/deps/papi && \
git checkout tags/papi-5-7-0-t -b papi-5-7-0 && \
cd src && \
./configure --prefix=${ROOT_DIR}/lib/papi && make -j 4 && make install

stat=$?
if [ $stat -ne 0 ]; then
    echo "compile papi fails"
    exit 1
fi

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

cd ${ROOT_DIR} && cp install.sh cab-mpi

# Benchmark branch compile
cd ${ROOT_DIR}/cab-mpi

# install standard MPICH
git checkout pmodel-master
./autogen.sh | tee autogen.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "std mpich autogen fails - please check autotools configuration"
    exit 1
fi

INSTALLED_NAME=mpich-std
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

if [ $stats -ne 0 ]; then
    echo "std mpich compilation fails"
    exit 1
fi

git checkout rebase-pip-pingpong-original && \
./autogen.sh | tee autogen.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "pingpong original mpich autogen fails - please check autotools configuration"
    exit 1
fi

# pingpong original broadwell
INSTALLED_NAME=mpich-pingpong-original-bdw
export MPICHLIB_CFLAGS="-DBEBOP -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "original mpich (bdw) compilation fails"
    exit 1
fi

# pingpong original KNL
INSTALLED_NAME=mpich-pingpong-original-knl
export MPICHLIB_CFLAGS="-DKNL -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "original mpich (knl) compilation fails"
    exit 1
fi

# pingpong localized broadwell

INSTALLED_NAME=mpich-pingpong-localized-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout rebase-pip-pingpong-localized && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "localized mpich (bdw) compilation fails"
    exit 1
fi

# pingpong localized knl
INSTALLED_NAME=mpich-pingpong-localized-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "localized mpich (knl) compilation fails"
    exit 1
fi

# pingpong mixed broadwell
INSTALLED_NAME=mpich-pingpong-mixed-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout rebase-pip-pingpong-mixed && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "mixed mpich (bdw) compilation fails"
    exit 1
fi

# pingpong mixed knl
INSTALLED_NAME=mpich-pingpong-mixed-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "mixed mpich (knl) compilation fails"
    exit 1
fi


#pingpong throughput bdw
INSTALLED_NAME=mpich-pingpong-throughput-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout rebase-pip-pingpong-throughput && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (bdw) compilation fails"
    exit 1
fi

# pingpong throughput knl
INSTALLED_NAME=mpich-pingpong-throughput-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (knl) compilation fails"
    exit 1
fi

# Opt branch compile
# throughput-aware bdw
INSTALLED_NAME=mpich-throughput-aware-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout rebase-pip-throughput-aware && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (bdw) compilation fails"
    exit 1
fi

# throughput-aware knl
INSTALLED_NAME=mpich-throughput-aware-knl
export MPICHLIB_CFLAGS="-DKNL -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput mpich (knl) compilation fails"
    exit 1
fi

#pingpong throughput rev bdw
INSTALLED_NAME=mpich-throughput-non-rev-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DENABLE_REVERSE_TASK_ENQUEUE -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout 816dc6b92571992bcfdd16645cac6371b0763b3f && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput non rev compilation fails"
    exit 1
fi


INSTALLED_NAME=mpich-throughput-rev-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DENABLE_REVERSE_TASK_ENQUEUE -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout 2eda99cdfba3ebcf08eb56379b64c0053e6c3177 && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput rev compilation fails"
    exit 1
fi

#pingpong dynamic chunk bdw
INSTALLED_NAME=mpich-chunk-check-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DENABLE_REVERSE_TASK_ENQUEUE -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout rebase-pip-dynamic-chunk-stealing && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput chunk chunk compilation fails"
    exit 1
fi

INSTALLED_NAME=mpich-dynamic-chunk-bdw
export MPICHLIB_CFLAGS="-DBEBOP -DENABLE_REVERSE_TASK_ENQUEUE -DMPIDI_PIP_SHM_GET_STEALING -DENABLE_DYNAMIC_CHUNK -DMPIDI_PIP_SHM_ACC_STEALING -DMPIDI_PIP_OFI_ACC_STEALING -DMPIDI_PIP_STEALING_ENABLE -DENABLE_CONTIG_STEALING -DENABLE_NON_CONTIG_STEALING -DENABLE_OFI_STEALING -DENABLE_PARTNER_STEALING -Wl,--dynamic-linker=${GLIBC_DIR}/lib/ld-2.17.so"
git checkout 3d6b170143c444bdb65b9fda2570218fd27a40d2 && \
sh install.sh ${INSTALLED_NAME} 2>&1 | tee install.log

stats=$?
if [ $stats -ne 0 ]; then
    echo "throughput chunk chunk compilation fails"
    exit 1
fi
