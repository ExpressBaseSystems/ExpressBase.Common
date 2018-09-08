-- Table: public.eb_role2user

-- DROP TABLE public.eb_role2user;

CREATE TABLE public.eb_role2user
(
    id serial,
    role_id integer,
    user_id integer,
    eb_del1 boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2user_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2user
    OWNER to postgres;

-- Index: eb_role2user_eb_del_idx

-- DROP INDEX public.eb_role2user_eb_del_idx;

CREATE INDEX eb_role2user_eb_del_idx
    ON public.eb_role2user USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_role2user_id_idx

-- DROP INDEX public.eb_role2user_id_idx;

CREATE UNIQUE INDEX eb_role2user_id_idx
    ON public.eb_role2user USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_role2user_role_id_idx

-- DROP INDEX public.eb_role2user_role_id_idx;

CREATE INDEX eb_role2user_role_id_idx
    ON public.eb_role2user USING btree
    (role_id)
    TABLESPACE pg_default;

-- Index: eb_role2user_user_id_idx

-- DROP INDEX public.eb_role2user_user_id_idx;

CREATE INDEX eb_role2user_user_id_idx
    ON public.eb_role2user USING btree
    (user_id)
    TABLESPACE pg_default;