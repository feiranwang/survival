#! /usr/bin/env python

import sys, random

i = -1
pid_set = set()
for line in sys.stdin:
  pid, filename, days, is_dead = line.strip().split('\t')

  is_censored = is_dead == 'f'
  if pid not in pid_set:
    i += 1
    pid_set.add(pid)
  print '\t'.join([pid, filename, days, str(is_censored), str(i), '\N'])
