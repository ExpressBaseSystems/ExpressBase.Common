CREATE TABLE eb_objects_ver
(
  id integer NOT NULL auto_increment,
  eb_objects_id integer,
  obj_changelog text,
  commit_uid integer,
  commit_ts timestamp,
  obj_json json,
  refid text,
  version_num text,
  major_ver_num integer,
  minor_ver_num integer,
  patch_ver_num integer,
  working_mode1 boolean DEFAULT false,
  status_id integer,
  ver_num text,
  working_mode char NOT NULL DEFAULT 'F',
  CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
  CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T' OR working_mode = 'F')
);

create index eb_objects_ver_eb_objects_id_idx on eb_objects_ver(eb_objects_id) using btree; 

create index eb_objects_ver_id_idx on eb_objects_ver(id) using btree; 

create index eb_objects_ver_status_id_idx on eb_objects_ver(status_id) using btree; 
