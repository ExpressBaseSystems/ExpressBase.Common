CREATE TABLE eb_files_bytea
(
  id integer auto_increment,
  filename text,
  bytea blob,
  meta json,
  filecategory integer,
  CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
);



CREATE INDEX eb_files_bytea_id_idx
    ON eb_files_bytea(id);