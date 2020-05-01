#!/bin/bash

ROOT_DIR=$(pwd)/../../
CURR_DIR=$(pwd)
############################
# Broadwell minighost Test
############################

# nobarrier speedup
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout runtime-measure-nobarrier && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-speedup

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-speedup miniGhost.x-original-speedup.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-speedup

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-speedup miniGhost.x-throughput-speedup.out

# xy face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout only-xy && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-xy

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-xy miniGhost.x-original-xy.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-xy

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-xy miniGhost.x-throughput-xy.out

# xz face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout only-xz && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-xz

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-xz miniGhost.x-original-xz.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-xz

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-xz miniGhost.x-throughput-xz.out

# yz face time measure
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && git checkout only-yz && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-original-yz

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-original-yz miniGhost.x-original-yz.out

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/miniGhost/ref && \
make clean && \
make && \
mv miniGhost.x miniGhost.x-throughput-yz

cd ${CURR_DIR} && \
sbatch ${SLURM_PARAM} bdw-xyz-nvar.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-throughput-yz miniGhost.x-throughput-yz.out