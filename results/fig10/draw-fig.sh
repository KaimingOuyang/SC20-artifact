#!/bin/bash

export TOOL_DIR=`pwd`/../tools

function parse_speedup {
    local file=$1
    echo $(cat ${file} | awk 'BEGIN{
        cnt = 0;
    }{
        key[cnt] = $1;
        speedup[cnt] = $2;
        devi[cnt] = $3;
        cnt++;
    }
    END{
        for(i=0;i<cnt;++i){
            if(i != cnt - 1)
                printf("%.3f\\t", key[i]);
            else
                printf("%.3f", key[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            if(i != cnt - 1)
                printf("%.3f\\t", speedup[i]);
            else
                printf("%.3f", speedup[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            if(i != cnt - 1)
                printf("%.3f\\t", devi[i]);
            else
                printf("%.3f", devi[i]);
        }
    }')
}

chunk_sizes=(98304 65536 32768 16384)

# draw fig10
cp data.template fig10.data
line_num=21
for chunk in ${chunk_sizes[@]}; do
    python3 ${TOOL_DIR}/parse_values.py pingpong-fix-chunk-bdw.out.${chunk} | tee -a pingpong-fix-chunk-bdw.out.${chunk}.final
    results=$(parse_speedup pingpong-fix-chunk-bdw.out.${chunk}.final)
    time=${results[1]}
    sed -i "${line_num}c ${time}" fig10.data
    sed -i "${line_num} s/^/\t/" fig10.data
    line_num=$((line_num + 3))
done

python3 ${TOOL_DIR}/parse_values.py pingpong-dynamic-chunk-bdw.out | tee -a pingpong-dynamic-chunk-bdw.out.final
results=$(parse_speedup pingpong-dynamic-chunk-bdw.out.final)
time=${results[1]}
sed -i "${line_num}c ${time}" fig10.data
sed -i "${line_num} s/^/\t/" fig10.data

python3 ${TOOL_DIR}/Painter.py fig10.data
