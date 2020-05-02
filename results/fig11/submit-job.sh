#!/bin/bash

ROOT_DIR=$(pwd)/../../
CURR_DIR=$(pwd)
############################
# Broadwell minighost Test
############################

# nobarrier speedup
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout -f runtime-measure-nobarrier && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-speedup

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-original-speedup compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-speedup miniGhost.x-original-speedup.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-speedup

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-throughput-speedup compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-speedup miniGhost.x-throughput-speedup.out

# xy face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout -f only-xy && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-xy

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-original-xy compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-xy miniGhost.x-original-xy.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-xy

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-throughput-xy compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-xy miniGhost.x-throughput-xy.out

# xz face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout -f only-xz && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-xz

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-original-xz compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-xz miniGhost.x-original-xz.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-xz

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-throughput-xz compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-xz miniGhost.x-throughput-xz.out

# yz face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout -f only-yz && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-yz

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-original-yz compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-yz miniGhost.x-original-yz.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-yz

stats=$?
if [ $stats != 0 ]; then
    echo "miniGhost.x-throughput-yz compilation error"
    exit 1
fi

cd ${CURR_DIR} && \
sbatch ${BDW_SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-yz miniGhost.x-throughput-yz.out