CREATE SEQUENCE eb_survey_queries_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_survey_queries
(
    id int default(NEXT VALUE FOR eb_survey_queries_id_seq) primary key,
    query varchar(max),
    q_type int
);

CREATE INDEX eb_survey_queries_id_idx ON eb_survey_queries(id);