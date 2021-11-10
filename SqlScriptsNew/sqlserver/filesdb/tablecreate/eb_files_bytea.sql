CREATE SEQUENCE eb_files_bytea_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_files_bytea
(
    id int default(NEXT VALUE FOR eb_files_bytea_id_seq) primary key,
    filename text,
    bytea bytea,
    meta json,
    filecategory integer,
    CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_files_bytea_id_idx
    ON eb_files_bytea(id);