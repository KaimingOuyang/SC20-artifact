#!/bin/bash

ROOT_DIR=$(pwd)/../../
############################
# Broadwell PingPong Non-contig Test
############################
# pingpong original procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc -o pingpong-ofi-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-ofi-original-bdw pingpong-ofi-original-bdw.out

# pingpong throughput procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-throughput-aware-bdw/bin:$PATH
mpicc -o pingpong-ofi-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-ofi-throughput-bdw pingpong-ofi-throughput-bdw.out