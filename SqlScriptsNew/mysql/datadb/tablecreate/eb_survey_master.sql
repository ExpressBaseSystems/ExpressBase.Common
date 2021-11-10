CREATE TABLE eb_survey_master
(
  id integer auto_increment,
  surveyid integer,
  userid integer,
  anonid integer,
  eb_createdate datetime,
  constraint eb_survey_master_pkey primary key(id)
);


CREATE INDEX eb_survey_master_id_idx
ON eb_survey_master(id);
