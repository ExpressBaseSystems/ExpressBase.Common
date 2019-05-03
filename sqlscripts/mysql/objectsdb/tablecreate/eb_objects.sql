CREATE TABLE eb_objects(
  id int NOT NULL auto_increment,
  obj_name varchar(255), 
  obj_type int,
  obj_cur_status int,
  obj_desc text,
  obj_tags text,
  owner_uid int,
  owner_ts timestamp,
  display_name text,
  is_logenabled char,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_objects_pkey PRIMARY KEY (id),
  CONSTRAINT uniq_obj_name UNIQUE (obj_name));
  

CREATE INDEX eb_objects_id_idx ON eb_objects (id) using btree;

CREATE INDEX eb_objects_type_idx
  ON eb_objects
  (obj_type)USING btree;

