#!/bin/bash

ROOT_DIR=$(pwd)/../../
############################
# Broadwell PingPong Non-contig Test
############################
# pingpong original procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc -o pingpong-pack-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc -o pingpong-pack-unpack-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-pack-original-bdw pingpong-pack-original-bdw.out
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-pack-unpack-original-bdw pingpong-pack-unpack-original-bdw.out

# pingpong throughput procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-throughput-aware-bdw/bin:$PATH
mpicc -o pingpong-pack-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc -o pingpong-pack-unpack-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-pack-throughput-bdw pingpong-pack-throughput-bdw.out
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-pack-unpack-throughput-bdw pingpong-pack-unpack-throughput-bdw.out