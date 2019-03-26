CREATE TABLE eb_locations
(
  id integer NOT NULL auto_increment,
  shortname varchar(20),
  longname text,
  image text,
  meta_json text,
  CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);


create index eb_locations_idx on eb_locations(id) using btree;


create index eb_locations_shortname_idx on eb_locations(shortname) using btree;
