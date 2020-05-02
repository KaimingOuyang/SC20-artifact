#!/bin/bash

ROOT_DIR=$(pwd)/../../
CFLAGS="-fpie -pie -rdynamic -pthread"
############################
# Broadwell PingPong Non-contig Test
############################
# pingpong original procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc ${CFLAGS} -o accumulate-original-bdw ${ROOT_DIR}/app/cab-benchmark/accumulate/accumulate.c
sbatch ${BDW_SLURM_PARAM} bdw-procs-intra-node.job accumulate-original-bdw accumulate-original-intra-bdw.out
sbatch ${BDW_SLURM_PARAM} bdw-procs-inter-node.job accumulate-original-bdw accumulate-original-inter-bdw.out

# pingpong throughput procs bdw
export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
mpicc ${CFLAGS} -o accumulate-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/accumulate/accumulate.c
sbatch ${BDW_SLURM_PARAM} bdw-procs-intra-node.job accumulate-throughput-bdw accumulate-throughput-intra-bdw.out
sbatch ${BDW_SLURM_PARAM} bdw-procs-inter-node.job accumulate-throughput-bdw accumulate-throughput-inter-bdw.out