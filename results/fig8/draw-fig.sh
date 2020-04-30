#!/bin/bash

export TOOL_DIR=`pwd`/../tools

cp data.template fig8.data

# draw fig8
# time
orig_data=$(python3 ${TOOL_DIR}/parse_values.py pingpong-original-time-bdw.out | awk '{print $2}')
thp_data=$(python3 ${TOOL_DIR}/parse_values.py pingpong-throughput-time-bdw.out | awk '{print $2}')

orig_data="${orig_data}\t$(python3 ${TOOL_DIR}/parse_values.py pingpong-original-cm-bdw.out | awk '{printf("%d\\t%d\\t%d", $2, $4, $6)}')"
thp_data="${thp_data}\t$(python3 ${TOOL_DIR}/parse_values.py pingpong-throughput-cm-bdw.out | awk '{printf("%d\\t%d\\t%d", $2, $4, $6)}')"

sed -i "19c ${orig_data}" fig8.data
sed -i "19 s/^/\t/" fig8.data
sed -i "22c ${thp_data}" fig8.data
sed -i "22 s/^/\t/" fig8.data
python3 ${TOOL_DIR}/Painter.py fig8.data
