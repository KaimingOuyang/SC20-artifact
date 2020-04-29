import sys
import math
basefile = open(sys.argv[1], "r")
improfile = open(sys.argv[2], "r")
cnt = {}
single = {}
total = {}
key_list = []
while True:
	baseline = basefile.readline()[:-1]
	if baseline == "":
		break
	baseitems = baseline.split(" ")
	improitems = improfile.readline()[:-1].split(" ")
	#print(baseitems, improitems)
	key = baseitems[0]
	values = [float(baseitems[i]) / float(improitems[i]) for i in range(1, len(baseitems))]
	
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
	#print(single[key])
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


