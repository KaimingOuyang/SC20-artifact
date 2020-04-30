#!/bin/bash

ROOT_DIR=$(pwd)/../../
############################
# KNL PingPong Non-contig Test
############################
# pingpong original procs knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-knl/bin:$PATH
mpicc -o pingpong-pack-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc -o pingpong-pack-unpack-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-pack-original-knl pingpong-pack-original-knl.out
sbatch ${SLURM_PARAM} knl-msg.job pingpong-pack-unpack-original-knl pingpong-pack-unpack-original-knl.out

# pingpong throughput procs knl
export PATH=$(ROOT_DIR)/installed/mpich-throughput-aware-knl/bin:$PATH
mpicc -o pingpong-pack-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc -o pingpong-pack-unpack-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-pack-throughput-knl pingpong-pack-throughput-knl.out
sbatch ${SLURM_PARAM} knl-msg.job pingpong-pack-unpack-throughput-knl pingpong-pack-unpack-throughput-knl.out