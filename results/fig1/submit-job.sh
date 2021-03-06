#!/bin/bash

ROOT_DIR=`pwd`/../..
export PATH=${ROOT_DIR}/installed/mpich-std/bin:$PATH

rm minighost-profile.out 2>&1 > /dev/null

cd ${ROOT_DIR}/app/miniGhost && \
git checkout -f communication-imbalance-profile && \
cd ref && \
make clean && make && \
mv miniGhost.x miniGhost.x-profile

stat=$?
if [ $stat -ne 0 ]; then
	echo "miniGhost compilation fails"
	exit 1
fi

# slurm script submission
cd ${ROOT_DIR}/results/fig1 && \
sbatch ${BDW_SLURM_PARAM} minighost-comm.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-profile




