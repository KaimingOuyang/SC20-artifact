#!/bin/bash

ROOT_DIR=$(pwd)/../..
CURR_DIR=$(pwd)
############################
# Broadwell bspmm Test
############################
export PATH=${ROOT_DIR}/installed/mpich-pingpong-original-bdw/bin:$PATH
cd ${ROOT_DIR}/app/BSPMM && \
make clean && \
make LDFLAGS="-L${ROOT_DIR}/lib/openblas/lib -Wl,-rpath=${ROOT_DIR}/lib/openblas/lib -lopenblas" C_INCLUDE="-I${ROOT_DIR}/lib/openblas/include" && \
mv bspmm_profile bspmm_profile_original

stats=$?
if [ $stats != 0 ]; then
	echo "BSPMM compilation error"
	exit 1
fi


nodes=(1 2 3 4 6 8 10 12 14 16 24 32)
#jobid=
cd ${CURR_DIR} && \
for N in ${nodes[@]}; do
	if [ $N == 1 ]; then
		dep_id=$(sbatch -N ${N} -t 12:00:00 bdw-strong-scaling.job ${ROOT_DIR}/app/BSPMM/bspmm_profile_original bspmm_profile_original.out ${N} | awk '{print $4}')
	else
		dep_id=$(sbatch --dependency=afterok:${dep_id} -N ${N} -t 12:00:00 bdw-strong-scaling.job ${ROOT_DIR}/app/BSPMM/bspmm_profile_original bspmm_profile_original.out ${N} | awk '{print $4}')
	fi

	stats=$?
	if [ $stats != 0 ]; then
		echo "BSPMM original $N nodes submission error"
		exit 1
	fi
done

export PATH=${ROOT_DIR}/installed/mpich-throughput-aware-bdw/bin:$PATH
cd ${ROOT_DIR}/app/BSPMM && \
make clean && \
make LDFLAGS="-L${ROOT_DIR}/lib/openblas/lib -Wl,-rpath=${ROOT_DIR}/lib/openblas/lib -lopenblas" C_INCLUDE="-I${ROOT_DIR}/lib/openblas/include" && \
mv bspmm_profile bspmm_profile_throughput

cd ${CURR_DIR} && \
for N in ${nodes[@]}; do
	if [ $N == 1 ]; then
		dep_id=$(sbatch -N ${N} -t 12:00:00 bdw-strong-scaling.job ${ROOT_DIR}/app/BSPMM/bspmm_profile_throughput bspmm_profile_throughput.out ${N} | awk '{print $4}')
	else
		dep_id=$(sbatch --dependency=afterok:${dep_id} -N ${N} -t 12:00:00 bdw-strong-scaling.job ${ROOT_DIR}/app/BSPMM/bspmm_profile_throughput bspmm_profile_throughput.out ${N} | awk '{print $4}')
	fi
	stats=$?
	if [ $stats != 0 ]; then
		echo "BSPMM throughput $N nodes submission error"
		exit 1
	fi
done