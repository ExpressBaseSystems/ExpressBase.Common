--SEQUENCE public.eb_role2permission_id_seq

CREATE SEQUENCE public.eb_role2permission_id_seq
    INCREMENT 1
    START 346
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_role2permission_id_seq
    OWNER TO postgres;

-- Table: public.eb_role2permission

-- DROP TABLE public.eb_role2permission;

CREATE TABLE public.eb_role2permission
(
    id integer NOT NULL DEFAULT nextval('eb_role2permission_id_seq'::regclass),
    role_id integer,
    eb_del1 boolean DEFAULT false,
    permissionname text COLLATE pg_catalog."default",
    createdby integer,
    createdat timestamp without time zone,
    obj_id integer,
    op_id integer,
    revokedby integer,
    revokedat timestamp without time zone,
    permissionname_backup text COLLATE pg_catalog."default",
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2permission
    OWNER to postgres;

-- Index: eb_role2permission_eb_del_idx

-- DROP INDEX public.eb_role2permission_eb_del_idx;

CREATE INDEX eb_role2permission_eb_del_idx
    ON public.eb_role2permission USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_role2permission_role_id_idx

-- DROP INDEX public.eb_role2permission_role_id_idx;

CREATE INDEX eb_role2permission_role_id_idx
    ON public.eb_role2permission USING btree
    (role_id)
    TABLESPACE pg_default;

-- Index: public.eb_role2permission_id_idx

-- DROP INDEX public.eb_role2permission_id_idx;

CREATE INDEX eb_role2permission_id_idx
    ON public.eb_role2permission USING btree
       (id)
    TABLESPACE pg_default;

