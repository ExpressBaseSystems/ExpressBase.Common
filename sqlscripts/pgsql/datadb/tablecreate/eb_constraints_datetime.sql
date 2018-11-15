-- Table: public.eb_constraints_datetime

-- DROP TABLE public.eb_constraints_datetime;

CREATE TABLE public.eb_constraints_datetime
(
    id serial,
    usergroup_id integer,
    type integer,
    start_datetime timestamp without time zone,
    end_datetime timestamp without time zone,
    days_coded integer,
    eb_del character(1) COLLATE pg_catalog."default" DEFAULT 'F'::bpchar,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_revoked_by integer,
    eb_revoked_at timestamp without time zone,
    title text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    CONSTRAINT eb_constraints_datetime_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_constraints_datetime
    OWNER to postgres;