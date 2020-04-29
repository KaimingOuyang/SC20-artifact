import sys
import math
data = open(sys.argv[1], "r")
cnt = {}
single = {}
total = {}
key_list = []
for line in data:
	items = line[:-1].split(" ")
	key = items[0]
	values = items[1:]
	
	single.setdefault(key, []).append([float(x) for x in values])
	total.setdefault(key, [])
	
	if(len(total[key]) == 0):
		total[key] = [float(x) for x in values]
	else:
		for i in range(0, len(values)):
			total[key][i] += float(values[i])

	cnt.setdefault(key, 0)
	cnt[key] += 1
	if key not in key_list:
		key_list.append(key)
	#print(size, msg_rate)

for key in key_list:
	total_cnt = cnt[key]
	average = [0.0 for j in range(0, len(total[key]))]
	for j in range(0, len(total[key])):
		average[j] = total[key][j] / total_cnt

	devi = [0.0 for j in range(0, len(total[key]))]
	for i in range(0, total_cnt):
		for j in range(0, len(total[key])):
			devi[j] += (single[key][i][j] - average[j]) * (single[key][i][j] - average[j])
	print("%s" % key, end=" ")
	for j in range(0, len(total[key])):
		devi[j] = math.sqrt(devi[j] / total_cnt)
		print("%.3f %.3f" % (average[j], devi[j]), end=" ")
	print("")


