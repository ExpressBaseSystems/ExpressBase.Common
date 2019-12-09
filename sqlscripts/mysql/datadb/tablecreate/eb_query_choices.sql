CREATE TABLE eb_query_choices
(
  id integer auto_increment,
  q_id integer,
  choice text,
  eb_del char(1) DEFAULT 'F',
  score integer,
  constraint eb_query_choices_key  primary key(id)
);



CREATE INDEX eb_query_choices_id_idx
ON eb_query_choices(id);

