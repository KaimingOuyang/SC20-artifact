#!/bin/bash

ROOT_DIR=$(pwd)/../../

############################
# KNL PingPong Test
############################
# pingpong original msg knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-knl/bin:$PATH
mpicc -o pingpong-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-original-knl pingpong-msg-original-knl.out

# pingpong localized msg knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-localized-knl/bin:$PATH
mpicc -o pingpong-localized-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-localized-knl pingpong-msg-localized-knl.out

# pingpong mixed msg knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-mixed-knl/bin:$PATH
mpicc -o pingpong-mixed-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-mixed-knl pingpong-msg-mixed-knl.out

# pingpong throughput msg knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-throughput-knl/bin:$PATH
mpicc -o pingpong-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${SLURM_PARAM} knl-msg.job pingpong-throughput-knl pingpong-msg-throughput-knl.out

# pingpong original procs knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-knl/bin:$PATH
sbatch ${SLURM_PARAM} knl-procs.job pingpong-original-knl pingpong-procs-original-knl.out

# pingpong localized procs knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-localized-knl/bin:$PATH
sbatch ${SLURM_PARAM} knl-procs.job pingpong-localized-knl pingpong-procs-localized-knl.out

# pingpong mixed procs knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-mixed-knl/bin:$PATH
sbatch ${SLURM_PARAM} knl-procs.job pingpong-mixed-knl pingpong-procs-mixed-knl.out

# pingpong throughput procs knl
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-throughput-knl/bin:$PATH
sbatch ${SLURM_PARAM} knl-procs.job pingpong-throughput-knl pingpong-procs-throughput-knl.out