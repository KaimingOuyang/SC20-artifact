#!/bin/bash

export TOOL_DIR=`pwd`/../tools

cp data.template fig3.data

rmts=(0 1 2 3 4 8 18)
line_num=15

for rmt in ${rmts[@]}; do
    python3 ${TOOL_DIR}/parse_values.py throughput-measure.out.${rmt} > throughput-measure.out.${rmt}.final
    strings=$(cat throughput-measure.out.${rmt}.final | awk 'BEGIN{
        cnt = 0;
    }{
        time[cnt] = $2;
        devi[cnt] = $3;
        cnt++;
    }
    END{
        for(i=0;i<cnt;++i){
            if(i != cnt - 1)
                printf("%.3f\\t", time[i]);
            else
                printf("%.3f", time[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            if(i != cnt - 1)
                printf("%.3f\\t", devi[i]);
            else
                printf("%.3f", devi[i]);
        }
    }')
    IFS=' ' read -r -a results <<< ${strings}
    time=${results[0]}
    devi=${results[1]}
    sed -i "${line_num}c ${time}" fig3.data
    sed -i "${line_num} s/^/\t/" fig3.data
    line_num=$((line_num + 2))
    sed -i "${line_num}c ${devi}" fig3.data
    sed -i "${line_num} s/^/\t/" fig3.data
    
    line_num=$((line_num + 3))
done

python3 ${TOOL_DIR}/Painter.py fig3.data
