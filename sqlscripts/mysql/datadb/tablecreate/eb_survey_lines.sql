CREATE TABLE eb_survey_lines
(
  id integer NOT NULL auto_increment,
  masterid integer,
  questionid integer,
  eb_createdate timestamp,
  choiceids text,
  questype integer,
  answer text,
  constraint eb_survey_lines_pkey primary key(id)
);



CREATE INDEX eb_survey_lines_idx
ON eb_survey_lines(id) 
USING btree;

CREATE INDEX eb_survey_lines_questionid_idx
ON eb_survey_lines(questionid) 
USING btree;
