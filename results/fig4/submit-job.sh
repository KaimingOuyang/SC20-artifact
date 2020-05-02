#!/bin/bash

ROOT_DIR=$(pwd)/../../
CFLAGS="-fpie -pie -rdynamic -pthread"
############################
# Broadwell PingPong Test
############################
# pingpong original msg bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-original-bdw pingpong-msg-original-bdw.out

# pingpong localized msg bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-localized-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-localized-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-localized-bdw pingpong-msg-localized-bdw.out

# pingpong mixed msg bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-mixed-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-mixed-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-mixed-bdw pingpong-msg-mixed-bdw.out

# pingpong throughput msg bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-throughput-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-throughput-bdw pingpong-msg-throughput-bdw.out

# pingpong original procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-original-bdw pingpong-procs-original-bdw.out

# pingpong localized procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-localized-bdw/bin:$PATH
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-localized-bdw pingpong-procs-localized-bdw.out

# pingpong mixed procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-mixed-bdw/bin:$PATH
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-mixed-bdw pingpong-procs-mixed-bdw.out

# pingpong throughput procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-throughput-bdw/bin:$PATH
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-throughput-bdw pingpong-procs-throughput-bdw.out

############################
# KNL PingPong Test
############################
# pingpong original msg knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${KNL_SLURM_PARAM} knl-msg.job pingpong-original-knl pingpong-msg-original-knl.out

# pingpong localized msg knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-localized-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-localized-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${KNL_SLURM_PARAM} knl-msg.job pingpong-localized-knl pingpong-msg-localized-knl.out

# pingpong mixed msg knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-mixed-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-mixed-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${KNL_SLURM_PARAM} knl-msg.job pingpong-mixed-knl pingpong-msg-mixed-knl.out

# pingpong throughput msg knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-throughput-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${KNL_SLURM_PARAM} knl-msg.job pingpong-throughput-knl pingpong-msg-throughput-knl.out

# pingpong original procs knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-knl/bin:$PATH
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-original-knl pingpong-procs-original-knl.out

# pingpong localized procs knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-localized-knl/bin:$PATH
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-localized-knl pingpong-procs-localized-knl.out

# pingpong mixed procs knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-mixed-knl/bin:$PATH
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-mixed-knl pingpong-procs-mixed-knl.out

# pingpong throughput procs knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-throughput-knl/bin:$PATH
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-throughput-knl pingpong-procs-throughput-knl.out

