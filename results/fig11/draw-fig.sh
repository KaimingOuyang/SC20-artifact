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
            printf("%d\\t", key[i]);
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

function clean_space_file {
    local file=$1
    cat ${file} | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}' > ${file}.final
}

cp data.template fig11.data

# speedup
clean_space_file miniGhost.x-original-speedup.out && \
tmp=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-speedup.out.final | awk '{printf("%.3f ", $2)}') && \
IFS=' ' read -r -a orig_time <<< ${tmp}

stats=$?
if [ $stats != 0 ]; then
    echo "read original time for speedup fails"
    exit 1
fi

clean_space_file miniGhost.x-throughput-speedup.out && \
tmp=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-speedup.out.final | awk '{printf("%.3f ", $2)}') && \
IFS=' ' read -r -a thp_time <<< ${tmp}

stats=$?
if [ $stats != 0 ]; then
    echo "read throughput time for speedup fails"
    exit 1
fi

speedup=""
for i in ${!orig_time[@]}; do
    if [ $i == 0 ]; then
        speedup+="$(echo "scale=3;${orig_time[i]} / ${thp_time[i]}" | bc)"
    else
        speedup="${speedup}\t$(echo "scale=3;${orig_time[i]} / ${thp_time[i]}" | bc)"
    fi
done

echo speedup=${speedup}
sed -i "47c ${speedup}" fig11.data && \
sed -i "47 s/^/\t/" fig11.data

stats=$?
if [ $stats != 0 ]; then
    echo "sed speedup fails"
    exit 1
fi

# performance breakdown
# compute time
clean_space_file miniGhost.x-original-xy.out && \
clean_space_file miniGhost.x-throughput-xy.out && \
orig_comp_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xy.out.final | awk '{printf("%.3f\\t", $4)}') && \
thp_comp_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xy.out.final | awk '{printf("%.3f\\t", $4)}') && \
# echo orig_comp_time=${orig_comp_time} && \
# echo thp_comp_time=${thp_comp_time} && \
orig_comp_time=${orig_comp_time::$((${#orig_comp_time}-2))} && \
thp_comp_time=${thp_comp_time::$((${#thp_comp_time}-2))}

stats=$?
if [ $stats != 0 ]; then
    echo "get compute time fails"
    exit 1
fi

sed -i "24c ${orig_comp_time}" fig11.data && \
sed -i "24 s/^/\t/" fig11.data && \
sed -i "36c ${thp_comp_time}" fig11.data && \
sed -i "36 s/^/\t/" fig11.data

stats=$?
if [ $stats != 0 ]; then
    echo "sed compute time fails"
    exit 1
fi

# xy time
orig_xy_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xy.out.final | awk '{printf("%.3f\\t", $8)}') && \
thp_xy_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xy.out.final | awk '{printf("%.3f\\t", $8)}') && \
orig_xy_time=${orig_xy_time::$((${#orig_xy_time}-2))} && \
thp_xy_time=${thp_xy_time::$((${#thp_xy_time}-2))}

stats=$?
if [ $stats != 0 ]; then
    echo "get xy comm time fails"
    exit 1
fi

sed -i "26c ${orig_xy_time}" fig11.data && \
sed -i "26 s/^/\t/" fig11.data && \
sed -i "38c ${thp_xy_time}" fig11.data && \
sed -i "38 s/^/\t/" fig11.data

stats=$?
if [ $stats != 0 ]; then
    echo "sed xy comm time fails"
    exit 1
fi

# xz time
clean_space_file miniGhost.x-original-xz.out && \
clean_space_file miniGhost.x-throughput-xz.out && \
orig_xz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-xz.out.final | awk '{printf("%.3f\\t", $14+$16)}') && \
thp_xz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-xz.out.final | awk '{printf("%.3f\\t", $14+$16)}') && \
orig_xz_time=${orig_xz_time::$((${#orig_xz_time}-2))} && \
thp_xz_time=${thp_xz_time::$((${#thp_xz_time}-2))}

stats=$?
if [ $stats != 0 ]; then
    echo "get xz comm time fails"
    exit 1
fi

sed -i "30c ${orig_xz_time}" fig11.data && \
sed -i "30 s/^/\t/" fig11.data && \
sed -i "42c ${thp_xz_time}" fig11.data && \
sed -i "42 s/^/\t/" fig11.data

stats=$?
if [ $stats != 0 ]; then
    echo "sed xz comm time fails"
    exit 1
fi

# yz time
clean_space_file miniGhost.x-original-yz.out && \
clean_space_file miniGhost.x-throughput-yz.out && \
orig_yz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-original-yz.out.final | awk '{printf("%.3f\\t", $10+$12)}') && \
thp_yz_time=$(python3 ${TOOL_DIR}/parse_values.py miniGhost.x-throughput-yz.out.final | awk '{printf("%.3f\\t", $10+$12)}') && \
orig_yz_time=${orig_yz_time::$((${#orig_yz_time}-2))} && \
thp_yz_time=${thp_yz_time::$((${#thp_yz_time}-2))}

stats=$?
if [ $stats != 0 ]; then
    echo "get yz comm time fails"
    exit 1
fi

sed -i "28c ${orig_yz_time}" fig11.data && \
sed -i "28 s/^/\t/" fig11.data  && \
sed -i "40c ${thp_yz_time}" fig11.data && \
sed -i "40 s/^/\t/" fig11.data

if [ $stats != 0 ]; then
    echo "sed yz comm time fails"
    exit 1
fi

python3 ${TOOL_DIR}/Painter.py fig11.data

