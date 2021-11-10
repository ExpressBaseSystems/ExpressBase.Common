-- Table: public.eb_user_types

-- DROP TABLE public.eb_user_types;

CREATE TABLE eb_user_types
(
    id SERIAL,
    name text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del  "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_user_types_pkey PRIMARY KEY (id)
);

-- Index: eb_user_types_id_idx

-- DROP INDEX public.eb_user_types_id_idx;

CREATE INDEX eb_user_types_id_idx
    ON eb_user_types(id);