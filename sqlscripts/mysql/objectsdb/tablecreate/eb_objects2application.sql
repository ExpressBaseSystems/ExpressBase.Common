CREATE TABLE eb_objects2application
(
  app_id int,
  id int NOT NULL auto_increment,
  obj_id int,
  eb_del1 boolean DEFAULT false,
  removed_by int,
  removed_at timestamp,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F'),
  CONSTRAINT eb_objects2application_pkey PRIMARY KEY(id)
);


CREATE INDEX eb_objects2application_app_id_idx
  ON eb_objects2application
  (app_id) USING btree;

CREATE INDEX eb_objects2application_eb_del_idx
  ON eb_objects2application
  (eb_del) USING btree;
  
  CREATE INDEX eb_objects2application_id_idx
  ON eb_objects2application
  (id) USING btree;
  
  CREATE INDEX eb_objects2application_obj_id_idx
  ON eb_objects2application
  (obj_id)USING btree;
