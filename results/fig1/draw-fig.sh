#!/bin/bash

ROOT_DIR=`pwd`/../..
TOOL_DIR=`pwd`/../tools

comm_time=`cat ./minighost-profile.out | awk '{print $1}'`
comp_time=`cat ./minighost-profile.out | awk '{print $3}'`
strings=$(cat ./minighost-profile.out | awk 'BEGIN{
    cnt = 0;
    max = 0.0;
}
{ 
    comm_time[cnt]=$1;
    comp_time[cnt]=$3;
    total_time[cnt]=$1 + $3;
    if(max < total_time[cnt]) {
        max = total_time[cnt]
    }; 
    cnt++;
}
END{
    #printf("%.3f ", max);

    for(i=0;i<cnt;++i){
        if(i != cnt - 1){
            printf("%.3f\\t", comp_time[i]);
        }else{
            printf("%.3f ", comp_time[i]);
        }
    }

    for(i=0;i<cnt;++i){
        if(i != cnt - 1){
            printf("%.3f\\t", comm_time[i]);
        }else{
            printf("%.3f ", comm_time[i]);
        }
    }

    for(i=0;i<cnt;++i){
        if(i != cnt - 1){
            printf("%.3f\\t", max - total_time[i]);
        }else{
            printf("%.3f", max - total_time[i]);
        }
    }
}')

IFS=' ' read -r -a results <<< "${strings}"
comp_time="${results[0]}"
comm_time="${results[1]}"
idle_time="${results[2]}"

cp data.template fig1.data
sed -i "26c ${comp_time}" fig1.data
sed -i '26 s/^/\t/' fig1.data
sed -i "28c ${comm_time}" fig1.data
sed -i '28 s/^/\t/' fig1.data
sed -i "30c ${idle_time}" fig1.data
sed -i '30 s/^/\t/' fig1.data

python3 ${TOOL_DIR}/Painter.py fig1.data