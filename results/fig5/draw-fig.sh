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

function generate_datafile {
    local task=$1
    local platform=$2
    local fig=$3
    cp data.template ${fig}
    zv=(256 4096 16384 65536 262144)
    line_num=17
    for z in ${zv[@]}; do
        python3 ${TOOL_DIR}/parse_speedup.py pingpong-${task}-original-${platform}.out.${z} pingpong-${task}-throughput-${platform}.out.${z} | tee pingpong-${task}-throughput-${platform}.speedup.${z}
        strings=$(parse_speedup pingpong-${task}-throughput-${platform}.speedup.${z})
        IFS=' ' read -r -a results <<< ${strings}
        key=${results[0]}
        speedup=${results[1]}
        devi=${results[2]}
        sed -i "${line_num}c ${speedup}" ${fig}
        sed -i "${line_num} s/^/\t/" ${fig}
        line_num=$((line_num + 2))
        sed -i "${line_num}c ${devi}" ${fig}
        sed -i "${line_num} s/^/\t/" ${fig}
        
        line_num=$((line_num + 3))
    done

    echo ${key}
}

# draw fig5 (a)
generate_datafile pack bdw fig5a.data > /dev/null
python3 ${TOOL_DIR}/Painter.py fig5a.data

# draw fig5 (b)
key=$(generate_datafile pack knl fig5b.data)
sed -i "4c ${key}" fig5b.data
sed -i "4 s/^/\t/" fig5b.data
python3 ${TOOL_DIR}/Painter.py fig5b.data

# draw fig5 (c)
generate_datafile pack-unpack bdw fig5c.data > /dev/null
python3 ${TOOL_DIR}/Painter.py fig5c.data

# draw fig5 (d)
key=$(generate_datafile pack-unpack knl fig5d.data)
sed -i "4c ${key}" fig5d.data
sed -i "4 s/^/\t/" fig5d.data
python3 ${TOOL_DIR}/Painter.py fig5d.data