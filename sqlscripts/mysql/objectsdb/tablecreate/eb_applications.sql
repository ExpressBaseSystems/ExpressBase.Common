CREATE TABLE eb_applications
(
  id integer NOT NULL auto_increment,
  applicationname text,
  description text,
  eb_del1 boolean DEFAULT false,
  application_type_old text,
  app_icon text,
  application_type integer,
  eb_del char NOT NULL DEFAULT 'F',
  app_settings text,
  CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
  CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_applications_eb_del_idx ON eb_applications (eb_del) USING btree;


CREATE INDEX eb_applications_id_idx ON eb_applications (id)USING btree;


