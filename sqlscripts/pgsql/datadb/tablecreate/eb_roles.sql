--SEQUENCE public.eb_roles_id_seq


CREATE SEQUENCE public.eb_roles_id_seq
    INCREMENT 1
    START 101
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_roles_id_seq
    OWNER TO postgres;

-- Table: public.eb_roles

-- DROP TABLE public.eb_roles;

CREATE TABLE public.eb_roles
(
    id integer NOT NULL DEFAULT (nextval('eb_roles_id_seq'::regclass) + 100),
    role_name text COLLATE pg_catalog."default" NOT NULL,
    eb_del1 boolean,
    applicationname text COLLATE pg_catalog."default",
    applicationid integer,
    description text COLLATE pg_catalog."default",
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    is_anonymous "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_rolename_unique UNIQUE (role_name),
    CONSTRAINT eb_roles_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_roles
    OWNER to postgres;

-- Index: eb_roles_eb_del_idx

-- DROP INDEX public.eb_roles_eb_del_idx;

CREATE INDEX eb_roles_eb_del_idx
    ON public.eb_roles USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_roles_id_idx

-- DROP INDEX public.eb_roles_id_idx;

CREATE UNIQUE INDEX eb_roles_id_idx
    ON public.eb_roles USING btree
    (id)
    TABLESPACE pg_default;