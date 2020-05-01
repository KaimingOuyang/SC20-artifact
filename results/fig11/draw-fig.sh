#!/bin/bash

export TOOL_DIR=`pwd`/../tools

function parse_speedup {
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
            printf("%.3f\\t", values[i]);
        }
        printf(" ");
        for(i=0;i<cnt;++i){
            printf("%.3f\\t", devi[i]);
        }
    }')
}

cp data.template fig11.data

# speedup
python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-speedup.out | awk '{printf("%.3f ", $2)}' | IFS=' ' read -r -a orig_time
python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-speedup.out | awk '{printf("%.3f ", $2)}' | IFS=' ' read -r -a thp_time
speedup=""
for i in ${!orig_time[@]}; do
    if [ $i != 0 ]; then
        speedup += "$(echo "scale=3;${orig_time[i]} / ${thp_time[i]}" | bc)"
    else
        speedup = "${speedup}\t$(echo "scale=3;${orig_time[i]} / ${thp_time[i]}" | bc)"
    fi
done

sed -i "47c ${speedup}" fig11.data
sed -i "47 s/^/\t/" fig11.data

# performance breakdown
# compute time
orig_comp_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xy.out | awk '{printf("%.3f\\t", $4)}')
thp_comp_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xy.out | awk '{printf("%.3f\\t", $4)}')
orig_comp_time=${orig_comp_time::-1}
thp_comp_time=${thp_comp_time::-1}

sed -i "24c ${orig_comp_time}" fig11.data
sed -i "24 s/^/\t/" fig11.data 
sed -i "36c ${thp_comp_time}" fig11.data
sed -i "36 s/^/\t/" fig11.data

# xy time
orig_xy_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xy.out | awk '{printf("%.3f\\t", $8)}')
thp_xy_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xy.out | awk '{printf("%.3f\\t", $8)}')
orig_xy_time=${orig_xy_time::-1}
thp_xy_time=${thp_xy_time::-1}

sed -i "26c ${orig_xy_time}" fig11.data
sed -i "26 s/^/\t/" fig11.data 
sed -i "38c ${thp_xy_time}" fig11.data
sed -i "38 s/^/\t/" fig11.data

# xz time
orig_xz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xz.out | awk '{printf("%.3f\\t", $14+$16)}')
thp_xz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xz.out | awk '{printf("%.3f\\t", $14+$16)}')
orig_xz_time=${orig_xz_time::-1}
thp_xz_time=${thp_xz_time::-1}

sed -i "30c ${orig_xz_time}" fig11.data
sed -i "30 s/^/\t/" fig11.data 
sed -i "42c ${thp_xz_time}" fig11.data
sed -i "42 s/^/\t/" fig11.data

# yz time
orig_yz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-yz.out | awk '{printf("%.3f\\t", $10+$12)}')
thp_yz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-yz.out | awk '{printf("%.3f\\t", $10+$12)}')
orig_yz_time=${orig_yz_time::-1}
thp_yz_time=${thp_yz_time::-1}

sed -i "28c ${orig_yz_time}" fig11.data
sed -i "28 s/^/\t/" fig11.data 
sed -i "40c ${thp_yz_time}" fig11.data
sed -i "40 s/^/\t/" fig11.data

python3 ${TOOL_DIR}/Painter.py fig11.data

