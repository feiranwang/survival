
DROP TABLE IF EXISTS patients CASCADE;
create table patients (
  pid text,
  survival_days int,
  is_dead boolean);

DROP TABLE IF EXISTS slides CASCADE;
create table slides (
  pid text,
  file text);

DROP TABLE IF EXISTS survival CASCADE;
create table survival (
  pid text,
  file text,
  label int,
  is_censored boolean,
  sid int,
  id bigint);


DROP TABLE IF EXISTS sentences CASCADE;
create table sentences(
  doc_id text,
  sent_id int,
  word_indexes int[],
  words text[],
  poses text[],
  ners text[],
  lemmas text[],
  dep_paths text[],
  dep_parents int[],
  bounding_boxes text[]
);

drop table if exists grades cascade;
create table grades (
  pid text,
  grade text
);

drop table if exists features cascade;
create table features (
  pid text,
  feature text
);

drop table if exists gene_features;
create table gene_features(
  pid text,
  index int,
  feature float,
  id bigint);

drop table if exists image_features;
create table image_features(
  pid text,
  index int,
  feature float,
  id bigint);
