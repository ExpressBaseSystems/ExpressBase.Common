CREATE TABLE eb_locations
(
   id integer auto_increment,
    shortname varchar(20) DEFAULT 'default',
    longname varchar(50) DEFAULT 'default',
    image text,
    meta_json text,
    eb_data_id integer,
    eb_ver_id integer,
    week_holiday1 text,
    week_holiday2 text,
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);


create index eb_locations_idx on eb_locations(id) using btree;


create index eb_locations_shortname_idx on eb_locations(shortname) using btree;
