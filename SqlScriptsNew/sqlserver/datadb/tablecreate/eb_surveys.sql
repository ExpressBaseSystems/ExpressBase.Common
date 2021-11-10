CREATE SEQUENCE eb_surveys_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_surveys
(
    id int default(NEXT VALUE FOR eb_surveys_id_seq) primary key,
    name varchar(max),
    startdate datetime2(6),
    enddate datetime2(6),
    status int,
    questions varchar(max) 
);

CREATE INDEX eb_surveys_id_idx ON eb_surveys(id);