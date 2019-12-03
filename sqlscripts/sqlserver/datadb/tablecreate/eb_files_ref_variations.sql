CREATE SEQUENCE eb_files_ref_variations_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_files_ref_variations
(
    id int default(NEXT VALUE FOR eb_files_ref_variations_id_seq) primary key,
    eb_files_ref_id int NOT NULL,
    filestore_sid varchar(max),
    length bigint,
    is_image char,
    imagequality_id int,
    img_manp_ser_con_id int,
    filedb_con_id int
);

CREATE INDEX eb_files_ref_variations_id_idx ON eb_files_ref_variations(id);

CREATE INDEX eb_files_variations_files_refid_idx ON eb_files_ref_variations(eb_files_ref_id);