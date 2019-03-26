CREATE TABLE eb_executionlogs
(
  id integer NOT NULL auto_increment,
  rows varchar(200),
  exec_time integer,
  created_by integer,
  created_at timestamp,
  refid text,
  params json,
  constraint eb_executionlogs_pkey primary key(id)
);

create index eb_executionlogs_idx on eb_executionlogs(id) using btree;
