#!/bin/bash

ROOT_DIR=`pwd`/../..
export PATH=${ROOT_DIR}/installed/mpich-std/bin:$PATH

cd ${ROOT_DIR}/app/miniGhost && \
git checkout communication-imbalance-profile && \
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
sbatch ${SLURM_PARAM} minighost-comm.job ${ROOT_DIR}/app/miniGhost/ref/miniGhost.x-profile




