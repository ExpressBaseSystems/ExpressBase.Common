CREATE SEQUENCE eb_keyvalue_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_keyvalue
(
    id int default (NEXT VALUE FOR eb_keyvalue_id_seq) primary key,
    key_id bigint NOT NULL,
    lang_id int NOT NULL,
    value varchar(max) 
);

CREATE INDEX eb_keyvalue_id_idx ON eb_keyvalue(id);