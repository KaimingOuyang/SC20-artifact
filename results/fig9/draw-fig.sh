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

# draw fig9(a)
cp data.template fig9a.data

parse_speedup pingpong-original-tb-intra-bdw.out | IFS=' ' read -r -a results
orig_intra=${results[1]}

parse_speedup pingpong-throughput-tb-intra-bdw.out | IFS=' ' read -r -a results
thp_intra=${results[1]}

tmp=$(echo -e ${orig_intra} | tr "\t" " ")
IFS=' ' read -r -a orig_intra_array <<< $tmp
tmp=$(echo -e ${thp_intra} | tr "\t" " ")
IFS=' ' read -r -a thp_intra_array <<< $tmp
speedup_intra=""
for i in ${!orig_intra_array[@]}; do
    if [ $i -ne 0 ]; then
        speedup_intra="${speedup_intra}\t$(echo "scale=3;${orig_intra_array[i]}/${thp_intra_array[i]}" | bc)"
    else
        speedup_intra="$(echo "scale=3;${orig_intra_array[i]}/${thp_intra_array[i]}" | bc)"
done

sed -i "13c ${orig_intra_array}" fig9a.data
sed -i "13 s/^/\t/" fig9a.data
sed -i "16c ${thp_intra_array}" fig9a.data
sed -i "16 s/^/\t/" fig9a.data
sed -i "23c ${speedup_intra}" fig9a.data
sed -i "23 s/^/\t/" fig9a.data

python3 ${TOOL_DIR}/Painter.py fig9a.data

#draw fig9(b)
cp data.template fig9b.data

parse_speedup pingpong-original-tb-inter-bdw.out | IFS=' ' read -r -a results
orig_inter=${results[1]}

parse_speedup pingpong-throughput-tb-inter-bdw.out | IFS=' ' read -r -a results
thp_inter=${results[1]}

tmp=$(echo -e ${orig_inter} | tr "\t" " ")
IFS=' ' read -r -a orig_inter_array <<< $tmp
tmp=$(echo -e ${thp_inter} | tr "\t" " ")
IFS=' ' read -r -a thp_inter_array <<< $tmp
speedup_inter=""
for i in ${!orig_inter_array[@]}; do
    if [ $i -ne 0 ]; then
        speedup_inter="${speedup_inter}\t$(echo "scale=3;${orig_inter_array[i]}/${thp_inter_array[i]}" | bc)"
    else
        speedup_inter="$(echo "scale=3;${orig_inter_array[i]}/${thp_inter_array[i]}" | bc)"
done

sed -i "13c ${orig_inter_array}" fig9b.data
sed -i "13 s/^/\t/" fig9b.data
sed -i "16c ${thp_inter_array}" fig9b.data
sed -i "16 s/^/\t/" fig9b.data
sed -i "23c ${speedup_inter}" fig9b.data
sed -i "23 s/^/\t/" fig9b.data

python3 ${TOOL_DIR}/Painter.py fig9b.data
