CREATE TABLE eb_query_choices
(
  id integer NOT NULL auto_increment,
  q_id integer,
  choice text,
  eb_del char DEFAULT 'F',
  score integer,
  constraint eb_query_choices_key  primary key(id)
);



CREATE INDEX eb_query_choices_idx
ON eb_query_choices(id) 
USING btree;

CREATE INDEX eb_query_choices_qid_idx
ON eb_query_choices(q_id) 
USING btree;
