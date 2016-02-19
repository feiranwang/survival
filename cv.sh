#! /usr/bin/env bash

n=461
runs=5
range=$((n/runs+1))

for i in $(seq 1 $runs); do
  export STARTPID=$(((i - 1) * range))
  export ENDPID=$((i * range))
  deepdive run inf
  deepdive sql "drop table if exists cv_sid_$i; create table cv_sid_$i as select sid from survival s, dd_graph_variables_holdout d where s.id = d.variable_id"
  deepdive sql "drop table if exists survival_label_inference_$i; create table survival_label_inference_$i as select * from survival_label_inference"
done

deepdive sql "drop table if exists cv_results cascade; create table cv_results (x int, time int, status int);"

for i in $(seq 1 $runs); do
  STARTPID=$(((i - 1) * range))
  ENDPID=$((i * range))
  deepdive sql "drop table if exists train_median_$i cascade; create table train_median_$i as select median(expectation) from survival_label_inference_$i where sid < $STARTPID or sid >= $ENDPID"
  deepdive sql "insert into cv_results select (expectation > (select * from train_median_$i))::int, label, (1-is_censored::int) from survival_label_inference_$i where sid >= $STARTPID and sid < $ENDPID"
done

deepdive sql "copy(select * from cv_results) to stdout csv header" > results_tmp.csv
Rscript evaluate.R results_tmp.csv

