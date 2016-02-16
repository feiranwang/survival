#! /usr/bin/env python

import sys

# common words that are not useful...
filter_set = set(['report', 'tumor', 'cell', 'diagnosis', 'lung', 'level', 'grade', 'patient', 'tumour', 'stage'])

for row in sys.stdin:
  doc_id, lemmas, poses = row.strip().split('\t')
  pid = doc_id[:12]
  lemmas = lemmas.split('~^~')
  poses = poses.split('~^~')
  features = []

  # like feature
  # e.g., plaque-like area ...
  for i in xrange(len(lemmas)):
    if lemmas[i] == 'like':
      # find the noun or adj before like
      for j in xrange(i-1, -1, -1):
        if poses[j].startswith('J') or poses[j].startswith('N'):
          features.append('like=' + lemmas[j])
          break

  # bag of words
  for i in xrange(len(lemmas)):
    if poses[i].startswith('J') and len(lemmas[i]) >= 3:
      features.append('ADJ=' + lemmas[i])
    if poses[i].startswith('N'):
      # filter out some short nonsense
      if len(lemmas[i]) >= 4 and lemmas[i].lower() not in filter_set:
        features.append('NOUN=' + lemmas[i])

  
  for f in features:
    print '\t'.join([pid, f])

