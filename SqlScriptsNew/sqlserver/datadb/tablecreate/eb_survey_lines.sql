CREATE SEQUENCE eb_survey_lines_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_survey_lines
(
    id int default(NEXT VALUE FOR eb_survey_lines_id_seq) primary key,
    masterid int,
    questionid int,
    eb_createdate datetime2(6),
    choiceids varchar(max),
    questype int,
    answer varchar(max)
)

CREATE INDEX eb_survey_lines_log_id_idx ON eb_survey_lines(id);