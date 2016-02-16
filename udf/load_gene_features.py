#! /usr/bin/env python

import sys, math
import numpy as np

pids = []
with open(sys.argv[2]) as f:
  for line in f:
    pids.append(line.strip())

pid_set = set()
with open(sys.argv[3]) as f:
  for line in f:
    pid_set.add(line.split(',')[0])

i = 0
pid_list = []
feature_matrix = []
with open(sys.argv[1]) as f:
  for line in f:
    if pids[i] not in pid_set:
      i += 1
      continue
    features = [float(x) for x in line.strip().split(",")]
    feature_matrix.append(features)
    pid_list.append(pids[i])
    i += 1
    # maxf = max(features)
    # features = [x / maxf for x in features]

feature_matrix = np.array(feature_matrix)
row_max = np.max(feature_matrix, axis=0)
row_max[row_max == 0] = 1
feature_matrix /= row_max
  
for i in xrange(feature_matrix.shape[0]):
  for j in xrange(feature_matrix.shape[1]):
    print '\t'.join([pid_list[i], str(j), str(feature_matrix[i,j]), '\N'])
