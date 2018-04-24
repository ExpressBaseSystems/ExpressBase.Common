-- SEQUENCE public.eb_user2usergroup_id_seq

CREATE SEQUENCE public.eb_user2usergroup_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_user2usergroup_id_seq
    OWNER TO postgres;

-- Table: public.eb_user2usergroup

-- DROP TABLE public.eb_user2usergroup;

CREATE TABLE public.eb_user2usergroup
(
    id integer NOT NULL DEFAULT nextval('eb_user2usergroup_id_seq'::regclass),
    userid integer,
    groupid integer,
    eb_del1 boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id),
    CONSTRAINT eb_user2usergroup_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_user2usergroup
    OWNER to postgres;

-- Index: eb_user2usergroup_eb_del_idx

-- DROP INDEX public.eb_user2usergroup_eb_del_idx;

CREATE INDEX eb_user2usergroup_eb_del_idx
    ON public.eb_user2usergroup USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_user2usergroup_groupid_idx

-- DROP INDEX public.eb_user2usergroup_groupid_idx;

CREATE INDEX eb_user2usergroup_groupid_idx
    ON public.eb_user2usergroup USING btree
    (groupid)
    TABLESPACE pg_default;

-- Index: eb_user2usergroup_id_idx

-- DROP INDEX public.eb_user2usergroup_id_idx;

CREATE INDEX eb_user2usergroup_id_idx
    ON public.eb_user2usergroup USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_user2usergroup_userid_idx

-- DROP INDEX public.eb_user2usergroup_userid_idx;

CREATE INDEX eb_user2usergroup_userid_idx
    ON public.eb_user2usergroup USING btree
    (userid)
    TABLESPACE pg_default;