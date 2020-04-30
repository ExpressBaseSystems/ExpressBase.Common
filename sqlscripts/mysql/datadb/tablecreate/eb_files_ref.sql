CREATE TABLE eb_files_ref
(
  id integer auto_increment,
  userid integer NOT NULL,
  filename text,
  tags text,
  filetype text,
  uploadts datetime,
  eb_del char(1) DEFAULT 'F',
  filecategory integer,  
  context text,
  context_sec text,
  CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
  CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_files_ref_id_idx
ON eb_files_ref(id);


CREATE INDEX eb_files_ref_userid_idx
ON eb_files_ref(userid);