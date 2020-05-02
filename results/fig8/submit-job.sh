#!/bin/bash

ROOT_DIR=$(pwd)/../../
LDFLAGS="-L${ROOT_DIR}/lib/papi/lib -Wl,-rapth=${ROOT_DIR}/lib/papi/lib"
############################
# Broadwell PingPong Non-contig Test
############################

# pingpong touching time
# original
export PATH=${ROOT_DIR}/installed/mpich-throughput-non-rev-bdw/bin:$PATH
mpicc -o pingpong-original-time-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-reverse.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-original-time-bdw pingpong-original-time-bdw.out

# throughput
export PATH=${ROOT_DIR}/installed/mpich-throughput-rev-bdw/bin:$PATH
mpicc -o pingpong-throughput-time-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-reverse.c
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-throughput-time-bdw pingpong-throughput-time-bdw.out

# pingpong cache misses
# original
export PATH=${ROOT_DIR}/installed/mpich-throughput-non-rev-bdw/bin:$PATH
mpicc -o pingpong-original-cm-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-reverse-papi.c ${LDFLAGS}
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-original-cm-bdw pingpong-original-cm-bdw.out

# throughput
export PATH=${ROOT_DIR}/installed/mpich-throughput-rev-bdw/bin:$PATH
mpicc -o pingpong-throughput-cm-bdw ${ROOT_DIR}/app/cab-benchmark/pingpong/pingpong-reverse-papi.c ${LDFLAGS}
sbatch ${BDW_SLURM_PARAM} bdw-msg.job pingpong-throughput-cm-bdw pingpong-throughput-cm-bdw.out