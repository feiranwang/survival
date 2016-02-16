#! /usr/bin/env bash

n=184
runs=4
range=$((n/runs+1))

for i in $(seq 1 $runs); do
  export STARTPID=$(((i - 1) * range))
  export ENDPID=$((i * range))
  deepdive run inf
  deepdive sql "drop table if exists cv_sid_$i; create table cv_sid_$i as select sid from survival s, dd_graph_variables_holdout d where s.id = d.variable_id"
  deepdive sql "drop table if exists survival_label_inference_$i; create table survival_label_inference_$i as select * from survival_label_inference"
  deepdive sql "drop table if exists survival_inference_$i; create table survival_inference_$i as select distinct on (pid, file) pid, file, sid, label, is_censored, category, expectation from survival_label_inference_$i order by pid, file, expectation desc;"
  # deepdive sql "drop table if exists survival_inference_$i; create table survival_inference_$i as select distinct on (pid) pid, category from (select pid, category, count(category) as count from survival_label_inference_$i group by pid, category) a order by pid, count desc"
done

deepdive sql "drop table if exists cv_results cascade; create table cv_results as select * from survival_inference_1 limit 0"

for i in $(seq 1 $runs); do
  STARTPID=$(((i - 1) * range))
  ENDPID=$((i * range))
  # deepdive sql "select median(category) from survival_label_inference_$i where sid < $STARTPID or sid >= $ENDPID"
  deepdive sql "insert into cv_results select * from survival_inference_$i where sid >= $STARTPID and sid < $ENDPID"
done

deepdive sql "select median(category) from cv_results"
deepdive sql "create or replace view result as select category < (select median(category) from cv_results) as x, survival_days as time, is_dead :: int as status from cv_results, patients where cv_results.pid = patients.pid;"

deepdive sql "copy(select * from result) to stdout csv header" > results_tmp.csv
Rscript evaluate.R results_tmp.csv

