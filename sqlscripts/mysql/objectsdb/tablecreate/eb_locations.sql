CREATE TABLE eb_locations
(
	id integer auto_increment,
    shortname varchar(25) DEFAULT 'default',
    longname varchar(200) DEFAULT 'default',
    image text,
    meta_json text,
    eb_data_id integer,
    eb_ver_id integer,
    week_holiday1 text,
    week_holiday2 text,
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_locations_id_idx
    ON eb_locations(id);

