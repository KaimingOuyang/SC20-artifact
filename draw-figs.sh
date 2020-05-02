#!/bin/bash
export ROOT_DIR=$(pwd)
folders=(fig1 fig3 fig4 fig5 fig6 fig7 fig8 fig9 fig10 fig11 fig12)
for folder in ${folders[@]}; do
    cd results/${folder} && \
    sh draw-fig.sh && cd ${ROOT_DIR}
    
    stats=$?
    if [ $stats != 0 ]; then
        echo "Generate figures in ${folders} fails"
        exit 1
    fi
done
