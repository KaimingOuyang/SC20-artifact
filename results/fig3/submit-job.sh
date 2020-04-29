#!/bin/bash

ROOT_DIR=$(pwd)/../../
export TOOL_DIR=`pwd`/../tools
# this parameter may be changed
SLURM_PARAM="-N 1 -p bdwall -t 3:00:00"

export PATH=$(ROOT_DIR)/installed/mpich-std/bin:$PATH

mpicc -o throughput-measure ${ROOT_DIR}/app/cab-benchmark/throughput-measure/memcpy.c

sbatch ${SLURM_PARAM} throughput-measure throughput-measure.out