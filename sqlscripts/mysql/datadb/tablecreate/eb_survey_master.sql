CREATE TABLE eb_survey_master
(
  id integer NOT NULL auto_increment,
  surveyid integer,
  userid integer,
  anonid integer,
  eb_createdate timestamp,
  constraint eb_survey_master_pkey primary key(id)
);


CREATE INDEX eb_survey_master_idx
ON eb_survey_master(id) 
USING btree;

CREATE INDEX eb_survey_master_surveyid_idx
ON eb_survey_master(surveyid) 
USING btree;

CREATE INDEX eb_survey_master_userid_idx
ON eb_survey_master(userid) 
USING btree;