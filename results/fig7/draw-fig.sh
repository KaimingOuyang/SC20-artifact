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
    local type=$1
    local fig=$2
    cp data.template ${fig}
    line_num=17
    tile_dims=(64 128 256 512 1024)
    for tile_dim in ${tile_dims[@]}; do
        python3 ${TOOL_DIR}/parse_speedup.py accumulate-original-${type}-bdw.out.${tile_dim} accumulate-throughput-${type}-bdw.out.${tile_dim} | tee accumulate-throughput-${type}-bdw.speedup.${tile_dim}
        strings=$(parse_speedup accumulate-throughput-${type}-bdw.speedup.${tile_dim})
        IFS=' ' read -r -a results <<< ${strings}
        key=${results[0]}
        values=${results[1]}
        devi=${results[2]}
        sed -i "${line_num}c ${values}" ${fig}
        sed -i "${line_num} s/^/\t/" ${fig}
        line_num=$((line_num + 2))
        sed -i "${line_num}c ${devi}" ${fig}
        sed -i "${line_num} s/^/\t/" ${fig}
        line_num=$((line_num + 3))
    done
    echo ${key}
}

# draw fig7 (a)
generate_datafile intra fig7a.data > /dev/null
python3 ${TOOL_DIR}/Painter.py fig7a.data

# draw fig7 (b)
key=$(generate_datafile inter fig7b.data)
for i in ${!key[@]}; do
    key[i]=$((key[i] / 2))
done
sed -i "4c ${key}" ${fig}
sed -i "4 s/^/\t/" ${fig}
sed -i "6c #Processes (On Node 1)" ${fig}
sed -i "6 s/^/\t/" ${fig}
python3 ${TOOL_DIR}/Painter.py fig7b.data
