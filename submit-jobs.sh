#!/bin/bash

export ROOT_DIR=$(pwd)
export BDW_PARTITION="-p bdwall"
export KNL_PARTITION="-p knlall"
export BDW_SLURM_PARAM="${BDW_PARTITION}"
export KNL_SLURM_PARAM="${KNL_PARTITION}"

folders=(fig1 fig3 fig4 fig5 fig6 fig7 fig8 fig9 fig10 fig11 fig12)
for folder in ${folders[@]}; do
    cd results/${folder} && \
    sh submit-job.sh && cd ${ROOT_DIR}
    
    stats=$?
    if [ $stats != 0 ]; then
        echo "Submitting jobs in ${folders} fails"
        exit 1
    fi
done
