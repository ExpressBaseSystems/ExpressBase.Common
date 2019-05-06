-- Table: public.eb_usergroup

-- DROP TABLE public.eb_usergroup;

CREATE TABLE public.eb_usergroup
(
    id serial primary key,
    name text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    eb_del1 boolean,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id),
    CONSTRAINT eb_usergroup_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_usergroup
    OWNER to postgres;

-- Index: eb_usergroup_eb_del_idx

-- DROP INDEX public.eb_usergroup_eb_del_idx;

CREATE INDEX eb_usergroup_eb_del_idx
    ON public.eb_usergroup USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_usergroup_id_idx

-- DROP INDEX public.eb_usergroup_id_idx;

CREATE INDEX eb_usergroup_id_idx
    ON public.eb_usergroup USING btree
    (id)
    TABLESPACE pg_default;