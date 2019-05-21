CREATE TABLE eb_files_ref
(
  id integer NOT NULL auto_increment,
  userid integer NOT NULL,
  filename varchar(75),
  tags text,
  filetype text,
  uploadts timestamp,
  eb_del char(1) DEFAULT 'F',
  filecategory integer,  
  context text,
  CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
  CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_files_ref_idx
ON eb_files_ref(id) 
USING btree;


CREATE INDEX eb_files_ref_userid_idx
ON eb_files_ref(userid) 
USING btree;


CREATE INDEX eb_files_ref_filename_idx
ON eb_files_ref(filename) 
USING btree;


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