#!/bin/bash

ROOT_DIR=`pwd`/../..
echo ${ROOT_DIR}

export PATH=${ROOT_DIR}/installed/mpich-pingpong-original/bin:$PATH

cd ${ROOT_DIR}/app/miniGhost && \
git checkout remotes/origin/communication-imbalance-profile && \
make clean && \
cd ref && make

stat=$?
if [ $stat -ne 0 ]; then
	echo "miniGhost compilation fails"
	exit 1
fi

# slurm script submission
sbatch -N 4 -t 1:00:00 minighost-comm.job miniGhost.x




