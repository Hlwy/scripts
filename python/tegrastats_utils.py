# -*- coding: utf-8 -*-
#!/usr/bin/env python

"""
	Created by: Hunter Young

	@description: The following contains functions that are designed specifically
for aiding in the interaction with data logs associated with supported data
sources that were recorded and generated using the Terrasentia robot framework.
The capabilities of the functions contained within include, but is not limited
to, the following:

	- Searching for all available datalog types (camera, lidar, etc.), and their
respective paths, contained within a specified directory

	- Support for multiple variations in the datalogs containing the same
essential information

"""

import os
import re
import fnmatch

# ========================================================
#                 Directory & Filepath Searching
# ========================================================
def find_ram(string_input, patterns=None, verbose=False):
	# Filename patterns associated with an acceptable datalog
	if patterns == None:
		patterns = ['RAM']

	strLst = string_input.split()
	count = 0
	idx = []
	for word in strLst:
		for pattern in patterns:
			if fnmatch.fnmatch(word, pattern):	# Check for a match
				idx.append(count)
		count += 1

	# See how many were found
	if len(idx) == 0: print("!!\t[WARNING] Nothing found!")
	# # If only one datalog found remove path element from paths list for easy usage
	if len(idx) == 1: idx = idx[0]

	lbl = strLst[idx]
	vals = strLst[idx+1].split('/')
	vals = [re.sub("[^0-9]", "", str) for str in vals]
	val = round((float(vals[0])/float(vals[1]))*100,2)

	if(verbose): print(lbl, val)
	return val



def find_cpu(string_input, patterns=None, verbose=False):
	# Filename patterns associated with an acceptable datalog
	if patterns == None:
		patterns = ['CPU']

	strLst = string_input.split()
	count = 0
	idx = []
	for word in strLst:
		for pattern in patterns:
			if fnmatch.fnmatch(word, pattern):	# Check for a match
				idx.append(count)
		count += 1

	# See how many were found
	if len(idx) == 0: print("!!\t[WARNING] Nothing found!")
	# # If only one datalog found remove path element from paths list for easy usage
	if len(idx) == 1: idx = idx[0]

	lbl = strLst[idx]
	cores = strLst[idx+1].split(',')
	vals = [0 if core == 'off' else core.split('%') for core in cores]

	newVals = []
	for val in vals:
		if isinstance(val,list):
			tmp = val[0]
		else:
			tmp = val

		try:
			tmp = re.sub("[^0-9]", "", tmp)
		except:
			print("nothing done")

		newVals.append(round(float(tmp),2))

	print(lbl, newVals)
	if(verbose): print(lbl, val)
	return val

# ========================================================
#				 	  MAIN SYSTEM CALL
# ========================================================
if __name__ == '__main__':


	tmpStr = "RAM 2019/7853MB (lfb 7x4MB) SWAP 0/1024MB (cached 0MB) CPU [0%@2036,off,off,0%@2034,0%@2034,0%@2033] EMC_FREQ 0%@1600 GR3D_FREQ 0%@1122 APE 150 BCPU@25C MCPU@25C GPU@23.5C PLL@25C Tboard@22C Tdiode@21.75C PMIC@100C thermal@24.4C VDD_IN 2455/2455 VDD_CPU 306/306 VDD_GPU 153/153 VDD_SOC 613/613 VDD_WIFI 76/76 VDD_DDR 806/806"
	tmpStr2 = "RAM 1633/7853MB (lfb 1197x4MB) CPU [65%@960,off,off,28%@960,21%@960,16%@960] EMC_FREQ 8%@665 GR3D_FREQ 0%@140 MSENC 115 NVDEC 268 APE 150 BCPU@36.5C MCPU@36.5C GPU@35C PLL@36.5C Tboard@33C Tdiode@34C PMIC@100C thermal@35.9C VDD_IN 2915/2934 VDD_CPU 383/383 VDD_GPU 153/153 VDD_SOC 613/613 VDD_WIFI 19/38 VDD_DDR 595/595"
	# find_ram(tmpStr)
	find_cpu(tmpStr)

	# ts = tmpStr.split()
	# print(ts)
