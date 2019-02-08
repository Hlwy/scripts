import csv
import numpy as np

file = '/home/hunter/Downloads/HW_CANdataAnalysis/60519009.csv'

with open(file, 'r') as fIn, open('outfile.csv','w') as fout:
    dataIn = list(csv.reader(fIn,delimiter=' '))
    for i in dataIn[1::]:
        writer = csv.writer(fout, delimiter=' ')
        if len(i) >= 8:
            if i[8] == 'idx:cfef31c':
                writer.writerow(i)
