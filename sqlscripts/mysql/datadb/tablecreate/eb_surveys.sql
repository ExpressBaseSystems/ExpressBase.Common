CREATE TABLE eb_surveys
(
  id integer NOT NULL auto_increment,
  name text,
  startdate timestamp DEFAULT CURRENT_TIMESTAMP,
  enddate timestamp DEFAULT CURRENT_TIMESTAMP,
  status integer,
  questions text,
  constraint eb_surveys_pkey primary key(id)
);

CREATE INDEX eb_surveys_idx
ON eb_surveys(id)
USING btree;