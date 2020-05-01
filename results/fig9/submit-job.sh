#!/bin/bash

ROOT_DIR=$(pwd)/../../
############################
# Broadwell PingPong Non-contig Test
############################

# pingpong touching time
# original
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc -o pingpong-original-tb-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-msg-intra-NUMA.job pingpong-original-tb-bdw pingpong-original-tb-intra-bdw.out
sbatch ${SLURM_PARAM} bdw-msg-inter-NUMA.job pingpong-original-tb-bdw pingpong-original-tb-inter-bdw.out

# throughput
export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
mpicc -o pingpong-throughput-tb-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-msg-intra-NUMA.job pingpong-throughput-tb-bdw pingpong-throughput-tb-intra-bdw.out
sbatch ${SLURM_PARAM} bdw-msg-inter-NUMA.job pingpong-throughput-tb-bdw pingpong-throughput-tb-inter-bdw.out
