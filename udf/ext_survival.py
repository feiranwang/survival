#! /usr/bin/env python

import sys, random

def get_label(days):
  thres = [180, 360, 720, 1080]
  # thres = [870, 1623, 2621, 3362]
  # thres = [595, 870, 1168, 1623, 2319, 2621, 3170, 3362, 4962]
  # thres = [340, 595, 778, 870, 988, 1168, 1422, 1623, 2175, 2319, 2621, 2974, 3170, 3362, 4962, 6813]
  for i in xrange(len(thres)):
    if days < thres[i]: break
  return i

i = -1
pid_set = set()
for line in sys.stdin:
  pid, filename, days, is_dead = line.strip().split('\t')
  label = get_label(int(days))
  # label = int(days) / 180
  # if label < 1:
  #   label = 0
  # elif label < 2:
  #   label = 1
  # elif label < 4:
  #   label = 2
  # elif label < 6:
  #   label = 3
  # else:
  #   label = 4

  is_censored = is_dead == 'f'
  if pid not in pid_set:
    i += 1
    pid_set.add(pid)
  print '\t'.join([pid, filename, str(label), str(is_censored), str(i), '\N'])
