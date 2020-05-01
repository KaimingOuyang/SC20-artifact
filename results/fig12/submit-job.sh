#!/bin/bash

ROOT_DIR=$(pwd)/../../
CURR_DIR=$(pwd)
############################
# Broadwell bspmm Test
############################
export PATH=$(ROOT_DIR)/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/BSPMM && \
make clean && \
make && mv bspmm_profile bspmm_profile_original

nodes=(1 2 3 4 6 8 10 12 14 16 24 32)
#jobid=
for N in ${nodes[@]}; do
	sbatch -N ${N} -t 6:00:00 bdw-strong-scaling.job $(ROOT_DIR)/app/BSPMM/bspmm_profile_original bspmm_profile_original.out ${N}
done

export PATH=$(ROOT_DIR)/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/BSPMM && \
make clean && \
make && mv bspmm_profile bspmm_profile_throughput

for N in ${nodes[@]}; do
	sbatch -N ${N} -t 6:00:00 bdw-strong-scaling.job $(ROOT_DIR)/app/BSPMM/bspmm_profile_throughput bspmm_profile_throughput.out ${N}
done