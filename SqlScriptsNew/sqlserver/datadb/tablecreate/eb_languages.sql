CREATE SEQUENCE eb_languages_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_languages
(
    id int default(NEXT VALUE FOR eb_languages_id_seq) primary key,
    language varchar(max) 
);

CREATE INDEX eb_languages_id_idx ON eb_languages(id);