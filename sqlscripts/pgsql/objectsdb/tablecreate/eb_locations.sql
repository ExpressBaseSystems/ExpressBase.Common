-- Table: public.eb_locations

-- DROP TABLE public.eb_locations;
CREATE TABLE eb_locations
(
    id SERIAL,
    shortname text,
    longname text,
    image text,
    meta_json text,
    firmcode integer,
    eb_ver_id integer,
    eb_data_id integer,
    week_holiday1 text,
    week_holiday2 text,
    parent_id numeric,
    is_group text,
    eb_location_types_id integer,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);

-- Index: eb_locationsid_idx

-- DROP INDEX public.eb_locationsid_idx;

CREATE INDEX eb_locations_id_idx
    ON eb_locations(id);
