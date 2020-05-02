#!/bin/bash

ROOT_DIR=$(pwd)/../../
CFLAGS="-fpie -pie -rdynamic -pthread"
############################
# Broadwell PingPong Non-contig Test
############################
# pingpong original procs bdw
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-pack-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc ${CFLAGS} -o pingpong-pack-unpack-original-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-pack-original-bdw pingpong-pack-original-bdw.out
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-pack-unpack-original-bdw pingpong-pack-unpack-original-bdw.out

# pingpong throughput procs bdw
export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-pack-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc ${CFLAGS} -o pingpong-pack-unpack-throughput-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-pack-throughput-bdw pingpong-pack-throughput-bdw.out
sbatch ${BDW_SLURM_PARAM} bdw-procs.job pingpong-pack-unpack-throughput-bdw pingpong-pack-unpack-throughput-bdw.out

############################
# KNL PingPong Non-contig Test
############################
# pingpong original procs knl
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-pack-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc ${CFLAGS} -o pingpong-pack-unpack-original-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-pack-original-knl pingpong-pack-original-knl.out
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-pack-unpack-original-knl pingpong-pack-unpack-original-knl.out

# pingpong throughput procs knl
export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-knl/bin:$PATH
mpicc ${CFLAGS} -o pingpong-pack-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack.c
mpicc ${CFLAGS} -o pingpong-pack-unpack-throughput-knl ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-pack-unpack.c
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-pack-throughput-knl pingpong-pack-throughput-knl.out
sbatch ${KNL_SLURM_PARAM} knl-procs.job pingpong-pack-unpack-throughput-knl pingpong-pack-unpack-throughput-knl.out