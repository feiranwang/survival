#! /usr/bin/env python

import sys, math
import numpy as np

pids = []
with open(sys.argv[1]) as f:
  for line in f:
    pids.append(line.strip().split(',')[0])

i = 0
feature_matrix = []
with open(sys.argv[2]) as f:
  for line in f:
    features = [float(x) for x in line.strip().split(",")]
    feature_matrix.append(features)

# feature_matrix = np.array(feature_matrix)
# row_max = np.max(feature_matrix, axis=0)
# row_max[row_max == 0] = 1
# feature_matrix /= row_max
  
for i in xrange(len(feature_matrix)):
  for j in xrange(len(feature_matrix[0])):
    print '\t'.join([pids[i], str(j), str(feature_matrix[i][j]), '\N'])
