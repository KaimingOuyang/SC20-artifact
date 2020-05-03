#!/bin/bash

ROOT_DIR=$(pwd)/../../
CFLAGS="-fpie -pie -rdynamic -pthread"
############################
# Broadwell PingPong dynamic chunk Test
############################

# pingpong touching time
# original
export PATH=${ROOT_DIR}/installed/mpich-chunk-check-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-fix-chunk-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg-fix.job pingpong-fix-chunk-bdw pingpong-fix-chunk-bdw.out

# throughput
export PATH=${ROOT_DIR}/installed/mpich-dynamic-chunk-bdw/bin:$PATH
mpicc ${CFLAGS} -o pingpong-dynamic-chunk-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-algo.c
sbatch ${BDW_SLURM_PARAM} bdw-msg-dynamic.job pingpong-dynamic-chunk-bdw pingpong-dynamic-chunk-bdw.out
