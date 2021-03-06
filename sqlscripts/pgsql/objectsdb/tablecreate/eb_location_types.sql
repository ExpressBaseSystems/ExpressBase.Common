-- Table: public.eb_location_types

-- DROP TABLE public.eb_location_types;

CREATE TABLE eb_location_types
(
    id SERIAL,
    type text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_location_types_pkey PRIMARY KEY (id)
);

-- Index: eb_location_types_id_idx

-- DROP INDEX public.eb_location_types_id_idx;

CREATE INDEX eb_location_types_id_idx ON eb_location_types(id);

-- Index: eb_location_types_eb_del_idx

-- DROP INDEX public.eb_location_types_eb_del_idx;

CREATE INDEX eb_location_types_eb_del_idx ON eb_location_types(eb_del);