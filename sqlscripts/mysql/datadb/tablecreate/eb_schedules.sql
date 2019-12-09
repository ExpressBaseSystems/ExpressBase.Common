CREATE TABLE eb_schedules
(
  id integer auto_increment,
  task json,
  created_by integer,
  created_at datetime,
  eb_del char(1) DEFAULT 'F',
  jobkey text,
  triggerkey text,
  status numeric,
  obj_id numeric,
  name text,
  constraint eb_schedules_pkey primary key(id)
);


CREATE INDEX eb_schedules_id_idx
ON eb_schedules(id);