CREATE TABLE eb_survey_queries
(
  id integer NOT NULL auto_increment,
  query text,
  q_type integer,
  constraint eb_survey_queries_pkey primary key(id)
);

CREATE INDEX eb_survey_queries_idx
ON eb_survey_queries(id) 
USING btree;