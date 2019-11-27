CREATE TABLE eb_objects_ver
(
  id integer NOT NULL auto_increment,
  eb_objects_id integer,
  obj_changelog text,
  commit_uid integer,
  commit_ts datetime,
  obj_json json,
  refid text,
  version_num text,
  major_ver_num integer,
  minor_ver_num integer,
  patch_ver_num integer,
  status_id integer,
  ver_num text,
  working_mode char NOT NULL DEFAULT 'F',
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
  CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T' OR working_mode = 'F')
);

CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON eb_objects_ver(eb_objects_id);

CREATE INDEX eb_objects_ver_id_idx
    ON eb_objects_ver(id);

CREATE INDEX eb_objects_ver_status_id_idx
    ON eb_objects_ver(status_id);