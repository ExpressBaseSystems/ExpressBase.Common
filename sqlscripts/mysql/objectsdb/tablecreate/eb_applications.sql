CREATE TABLE eb_applications
(
  id integer auto_increment,
  applicationname text,
  description text,
  app_icon text,
  application_type integer,
  eb_del char(1) DEFAULT 'F',
  app_settings text,
  CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
  CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_applications_eb_del_idx 
ON eb_applications(eb_del);


CREATE INDEX eb_applications_id_idx 
ON eb_applications(id);


