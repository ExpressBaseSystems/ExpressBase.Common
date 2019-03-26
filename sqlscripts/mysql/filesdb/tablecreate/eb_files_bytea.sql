CREATE TABLE eb_files_bytea
(
  id integer NOT NULL auto_increment,
  filename varchar(75),
  bytea blob,
  meta json,
  filecategory integer,
  CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
);



create index eb_files_bytea_idx 
on eb_files_bytea(id) 
using btree;


create index eb_files_bytea_filename_idx 
on eb_files_bytea(filename) 
using btree;


create index eb_files_bytea_filecategory_idx 
on eb_files_bytea(filecategory) 
using btree;