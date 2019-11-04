CREATE TABLE eb_files_ref_variations
(
  id integer NOT NULL auto_increment,
  eb_files_ref_id integer NOT NULL,
  filestore_sid varchar(100),
  length bigint,
  is_image char,
  imagequality_id integer,
  img_manp_ser_con_id integer,
  filedb_con_id integer,
  CONSTRAINT eb_files_ref_variations_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_files_ref_variations_idx
ON eb_files_ref_variations(id) 
USING btree;


CREATE INDEX eb_files_variations_files_refid_idx
ON eb_files_ref_variations(eb_files_ref_id) 
USING btree;


CREATE INDEX eb_files_variations_filestoresid_idx
ON eb_files_ref_variations(filestore_sid) 
USING btree;