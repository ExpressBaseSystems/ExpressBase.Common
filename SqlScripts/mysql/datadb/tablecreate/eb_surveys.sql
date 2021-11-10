CREATE TABLE eb_surveys
(
  id integer NOT NULL auto_increment,
  name text,
  startdate datetime,
  enddate datetime,
  status integer,
  questions text,
  constraint eb_surveys_pkey primary key(id)
);

CREATE INDEX eb_surveys_id_idx
ON eb_surveys(id);