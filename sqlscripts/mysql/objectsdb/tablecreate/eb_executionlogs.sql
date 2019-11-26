CREATE TABLE eb_executionlogs
(
  id integer NOT NULL auto_increment,
  `rows` text,
  exec_time integer,
  created_by integer,
  created_at datetime,
  refid text,
  params json,
  constraint eb_executionlogs_pkey primary key(id)
);

CREATE INDEX eb_executionlogs_id_idx 
ON eb_executionlogs(id);


