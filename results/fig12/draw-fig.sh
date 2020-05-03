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

cp data.template fig12.data
nodes=(1 2 3 4 6 8 10 12 14 16 24 32)

# original
# fop time
orig_fop_time="$(cat bspmm_profile_original.out | awk '{printf("%.3f\\t", $6)}')"
orig_fop_time=${orig_fop_time::-1}
#acc time
orig_acc_time="$(cat bspmm_profile_original.out | awk '{printf("%.3f\\t", $8)}')"
orig_acc_time=${orig_acc_time::-1}
#get time
orig_get_time="$(cat bspmm_profile_original.out | awk '{printf("%.3f\\t", $10)}')"
orig_get_time=${orig_get_time::-1}
#dgemm time
orig_dgemm_time="$(cat bspmm_profile_original.out | awk '{printf("%.3f\\t", $12)}')"
orig_dgemm_time=${orig_dgemm_time::-1}
#total time
orig_total_time="$(cat bspmm_profile_original.out | awk '{printf("%.3f ", $12)}')"
orig_total_time=${orig_total_time::-1}
echo ${orig_total_time::-1} | IFS=' ' read -r -a orig_total_array

line=28
types=(fop dgemm get acc)
for type in ${types[@]}; do
    var=orig_${type}_time
    sed -i "${line}c ${var}" fig12.data
    sed -i "${line} s/^/\t/" fig12.data
    line=$((line + 2))
done

# throughput
# fop time
thp_fop_time="$(cat bspmm_profile_throughput.out | awk '{printf("%.3f\\t", $6)}')"
thp_fop_time=${thp_fop_time::-1}
#acc time
thp_acc_time="$(cat bspmm_profile_throughput.out | awk '{printf("%.3f\\t", $8)}')"
thp_acc_time=${thp_acc_time::-1}
#get time
thp_get_time="$(cat bspmm_profile_throughput.out | awk '{printf("%.3f\\t", $10)}')"
thp_get_time=${thp_get_time::-1}
#dgemm time
thp_dgemm_time="$(cat bspmm_profile_throughput.out | awk '{printf("%.3f\\t", $12)}')"
thp_dgemm_time=${thp_dgemm_time::-1}
#total time
thp_total_time="$(cat bspmm_profile_throughput.out | awk '{printf("%.3f ", $12)}')"
echo ${thp_total_time::-1} | IFS=' ' read -r -a thp_total_array

line=40
types=(fop dgemm get acc)
for type in ${types[@]}; do
    var=thp_${type}_time
    sed -i "${line}c ${var}" fig12.data
    sed -i "${line} s/^/\t/" fig12.data
    line=$((line + 2))
done

speedup=""
for i in ${!orig_total_array[@]}; do
    if [ $i != 0 ]; then
        speedup="${speedup}\t$(echo "scale 3;${orig_total_array[i]}/${thp_total_array[i]}" | bc)"
    else
        speedup="$(echo "scale 3;${orig_total_array[i]}/${thp_total_array[i]}" | bc)"
    fi
done

sed -i "51c ${speedup}" fig12.data
sed -i "51 s/^/\t/" fig12.data

python3 ${TOOL_DIR}/Painter.py fig12.data

