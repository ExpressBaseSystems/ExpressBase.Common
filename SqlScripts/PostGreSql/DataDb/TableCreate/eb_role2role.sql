--SEQUENCE public.eb_role2role_id_seq

CREATE SEQUENCE public.eb_role2role_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_role2role_id_seq
    OWNER TO postgres;

-- Table: public.eb_role2role

-- DROP TABLE public.eb_role2role;

CREATE TABLE public.eb_role2role
(
    id integer NOT NULL DEFAULT nextval('eb_role2role_id_seq'::regclass),
    role1_id integer,
    role2_id integer,
    eb_del1 boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2role_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2role
    OWNER to postgres;

-- Index: eb_role2role_eb_del_idx

-- DROP INDEX public.eb_role2role_eb_del_idx;

CREATE INDEX eb_role2role_eb_del_idx
    ON public.eb_role2role USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_role2role_id_idx

-- DROP INDEX public.eb_role2role_id_idx;

CREATE UNIQUE INDEX eb_role2role_id_idx
    ON public.eb_role2role USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_role2role_role1_id_idx

-- DROP INDEX public.eb_role2role_role1_id_idx;

CREATE INDEX eb_role2role_role1_id_idx
    ON public.eb_role2role USING btree
    (role1_id)
    TABLESPACE pg_default;