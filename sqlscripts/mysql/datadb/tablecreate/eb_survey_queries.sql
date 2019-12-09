CREATE TABLE eb_survey_queries
(
  id integer auto_increment,
  query text,
  q_type integer,
  constraint eb_survey_queries_pkey primary key(id)
);

CREATE INDEX eb_survey_queries_id_idx
ON eb_survey_queries(id);