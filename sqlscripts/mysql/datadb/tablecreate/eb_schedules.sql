CREATE TABLE eb_schedules
(
  id integer NOT NULL auto_increment,
  task json,
  created_by integer,
  created_at timestamp,
  eb_del char,
  jobkey text,
  triggerkey text,
  status numeric,
  obj_id numeric,
  name text,
  constraint eb_schedules_pkey primary key(id)
);


CREATE INDEX eb_schedules_idx
ON eb_schedules(id) 
USING btree;