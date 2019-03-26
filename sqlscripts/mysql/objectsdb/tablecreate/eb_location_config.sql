CREATE TABLE eb_location_config
(
  id integer NOT NULL auto_increment,
  keys1 varchar(100),
  isrequired char,
  keytype text,
  eb_del char,
  CONSTRAINT eb_location_config_pkey PRIMARY KEY (id)
);



create index eb_location_config_idx on eb_location_config(id) using btree;

