CREATE TABLE eb_objects2application
(
  id integer auto_increment,
  app_id integer,  
  obj_id integer,
  removed_by integer,
  removed_at datetime,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F'),
  CONSTRAINT eb_objects2application_pkey PRIMARY KEY(id)
);


CREATE INDEX eb_objects2application_app_id_idx
    ON eb_objects2application(app_id);

CREATE INDEX eb_objects2application_eb_del_idx
    ON eb_objects2application(eb_del);

CREATE INDEX eb_objects2application_id_idx
    ON eb_objects2application(id);
 
CREATE INDEX eb_objects2application_obj_id_idx
    ON eb_objects2application(obj_id);