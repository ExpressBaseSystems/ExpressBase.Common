-- Table: public.eb_constraints_ip

-- DROP TABLE public.eb_constraints_ip;

CREATE TABLE public.eb_constraints_ip
(
    id serial,
    usergroup_id integer,
    ip text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    eb_del character(1) COLLATE pg_catalog."default" DEFAULT 'F'::bpchar,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_revoked_by integer,
    eb_revoked_at timestamp without time zone,
    CONSTRAINT eb_constraints_ip_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_constraints_ip
    OWNER to postgres;