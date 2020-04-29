#!/bin/bash

ROOT_DIR=$(pwd)/../../
############################
# Broadwell PingPong Test
############################
# pingpong original msg bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc -o pingpong-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} bdw-msg.job pingpong-original-bdw pingpong-msg-original-bdw.out

# pingpong localized msg bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-localized-bdw/bin:$PATH
mpicc -o pingpong-localized-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} bdw-msg.job pingpong-localized-bdw pingpong-msg-localized-bdw.out

# pingpong mixed msg bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-mixed-bdw/bin:$PATH
mpicc -o pingpong-mixed-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} bdw-msg.job pingpong-mixed-bdw pingpong-msg-mixed-bdw.out

# pingpong throughput msg bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-throughput-bdw/bin:$PATH
mpicc -o pingpong-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} bdw-msg.job pingpong-throughput-bdw pingpong-msg-throughput-bdw.out

# pingpong original procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-bdw/bin:$PATH
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-original-bdw pingpong-procs-original-bdw.out

# pingpong localized procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-localized-bdw/bin:$PATH
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-localized-bdw pingpong-procs-localized-bdw.out

# pingpong mixed procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-mixed-bdw/bin:$PATH
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-mixed-bdw pingpong-procs-mixed-bdw.out

# pingpong throughput procs bdw
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-throughput-bdw/bin:$PATH
sbatch ${SLURM_PARAM} bdw-procs.job pingpong-throughput-bdw pingpong-procs-throughput-bdw.out