#!/bin/bash
export ROOT_DIR=$(pwd)

mkdir ${ROOT_DIR}/results/figures 2>&1 > /dev/null

folders=(fig1 fig3 fig4 fig5 fig6 fig7 fig8 fig9 fig10 fig11 fig12)
for folder in ${folders[@]}; do
    cd results/${folder} && \
    sh draw-fig.sh && cp ${folder}.pdf ../figures && \
    cd ${ROOT_DIR}
    
    stats=$?
    if [ $stats != 0 ]; then
        echo "Generate figures in ${folders} fails"
        exit 1
    fi
done
