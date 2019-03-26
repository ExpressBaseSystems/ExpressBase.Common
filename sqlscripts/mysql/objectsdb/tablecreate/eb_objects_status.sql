CREATE TABLE eb_objects_status
(
  id integer NOT NULL auto_increment,
  refid text,
  status integer,
  uid integer,
  ts timestamp,
  eb_obj_ver_id integer,
  changelog text,
  CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
  ON eb_objects_status
(eb_obj_ver_id)USING btree;

CREATE INDEX eb_objects_status_id_idx
  ON eb_objects_status
  (id)USING btree;
  
  CREATE INDEX eb_objects_status_refid_id_idx
  ON eb_objects_status
  (refid(100))USING btree;