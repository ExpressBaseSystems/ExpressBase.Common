CREATE SEQUENCE eb_keys_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_keys
(
    id int default(NEXT VALUE FOR eb_keys_id_seq) primary key,
    "key" varchar(max)
);

CREATE INDEX eb_keys_id_idx ON eb_keys(id);