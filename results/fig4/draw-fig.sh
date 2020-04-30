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
            printf("%.3f\\t", key[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            printf("%.3f\\t", speedup[i]);
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
    types=(localized mixed throughput)
    line_num=17
    for type in ${types[@]}; do
        python3 ${TOOL_DIR}/parse_speedup.py pingpong-${task}-original-${platform}.out pingpong-${task}-${type}-${platform}.out | tee pingpong-${task}-${type}-${platform}.speedup
        strings=$(parse_speedup pingpong-${task}-${type}-${platform}.speedup)
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

# draw fig4 (a)
generate_datafile msg bdw fig4a.data > /dev/null
python3 ${TOOL_DIR}/Painter.py fig4a.data

# draw fig4 (b)
generate_datafile msg knl fig4b.data > /dev/null
python3 ${TOOL_DIR}/Painter.py fig4b.data

# draw fig4 (c)
key=$(generate_datafile procs bdw fig4c.data)
sed -i "4c ${key}" fig4c.data
sed -i "4 s/^/\t/" fig4c.data
sed -i "8c #Processes" fig4c.data
sed -i "8 s/^/\t/" fig4c.data

python3 ${TOOL_DIR}/Painter.py fig4c.data

# draw fig4 (d)
key=$(generate_datafile procs knl fig4d.data)
sed -i "4c ${key}" fig4d.data
sed -i "4 s/^/\t/" fig4d.data
sed -i "8c #Processes" fig4d.data
sed -i "8 s/^/\t/" fig4d.data
python3 ${TOOL_DIR}/Painter.py fig4d.data