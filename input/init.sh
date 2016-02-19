# deepdive sql "copy sentences from stdin" < input/sentences.tsv
deepdive sql "copy patients from stdin csv" < input/survival.csv
# deepdive sql "copy slides from stdin csv" < input/dense1.txt
deepdive sql "copy grades from stdin" < input/tcgaLUADGradeTruth.tsv
deepdive sql < input/median.sql


