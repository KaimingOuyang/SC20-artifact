#!/bin/bash

export TOOL_DIR=`pwd`/../tools

function parse_values {
    local file=$1
    echo $(cat ${file} | awk 'BEGIN{
        cnt = 0;
    }{
        key[cnt] = $1;
        values[cnt] = $2;
        devi[cnt] = $3;
        cnt++;
    }
    END{
        for(i=0;i<cnt;++i){
            printf("%.3f\\t", key[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            printf("%.3f\\t", time[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            printf("%.3f\\t", devi[i]);
        }
    }')
}

function generate_datafile {
    local task=$1
    local platform=$2
    local fig=$3
    cp data.template ${fig}
    line_num=17
    python3 ${TOOL_DIR}/parse_values.py pingpong-${task}-original-${platform}.out | tee pingpong-${task}-original-${platform}.out.final
    python3 ${TOOL_DIR}/parse_values.py pingpong-${task}-throughput-${platform}.out | tee pingpong-${task}-throughput-${platform}.out.final

    strings=$(parse_values pingpong-${task}-original-${platform}.out.final)
    IFS=' ' read -r -a results <<< ${strings}
    values=${results[1]}
    sed -i "${line_num}c ${values}" ${fig}
    sed -i "${line_num} s/^/\t/" ${fig}
    line_num=$((line_num + 3))

    strings=$(parse_values pingpong-${task}-throughput-${platform}.out.final)
    IFS=' ' read -r -a results <<< ${strings}
    values=${results[1]}
    sed -i "${line_num}c ${values}" ${fig}
    sed -i "${line_num} s/^/\t/" ${fig}
}

# draw fig5 (a)
generate_datafile ofi bdw fig6.data
python3 ${TOOL_DIR}/Painter.py fig6.data
