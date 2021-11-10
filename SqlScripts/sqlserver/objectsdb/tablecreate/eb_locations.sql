CREATE SEQUENCE eb_locations_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_locations
(
    id int default (NEXT VALUE FOR eb_locations_id_seq),
    shortname varchar(25) DEFAULT 'default',
    longname varchar(max) DEFAULT 'default',
    image varchar(max),
    meta_json varchar(max),
    eb_data_id integer,
    eb_ver_id integer,
    week_holiday1 varchar(max),
    week_holiday2 varchar(max),
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_locations_id_idx
    ON eb_locations(id);
