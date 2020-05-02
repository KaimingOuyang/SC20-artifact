#!/bin/bash

ROOT_DIR=$(pwd)/../../

export PATH=${ROOT_DIR}/installed/mpich-std/bin:$PATH
mpicc -o throughput-measure ${ROOT_DIR}/app/cab-benchmark/throughput-measure/memcpy.c
sbatch ${BDW_SLURM_PARAM} throughput-measure.job throughput-measure throughput-measure.out