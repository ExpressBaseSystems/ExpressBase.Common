--SEQUENCE public.eb_role2permission_id_seq

CREATE SEQUENCE public.eb_role2permission_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- Table: public.eb_role2permission

-- DROP TABLE public.eb_role2permission;

CREATE TABLE public.eb_role2permission
(
    id serial,
    role_id integer,
    eb_del1 boolean DEFAULT false,
    permissionname text,
    createdby integer,
    createdat timestamp without time zone,
    obj_id integer,
    op_id integer,
    revokedby integer,
    revokedat timestamp without time zone,
    permissionname_backup text,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

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

