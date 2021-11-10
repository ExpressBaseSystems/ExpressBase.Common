CREATE SEQUENCE eb_survey_master_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_survey_master
(
    id int default(NEXT VALUE FOR eb_survey_master_id_seq) primary key,
    surveyid int,
    userid int,
    anonid int,
    eb_createdate datetime2(6)
);

CREATE INDEX eb_survey_master_log_id_idx ON eb_survey_master(id);