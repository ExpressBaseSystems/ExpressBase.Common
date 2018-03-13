--SEQUENCE public.eb_userstatus_id_seq

CREATE SEQUENCE public.eb_userstatus_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_userstatus_id_seq
    OWNER TO postgres;

-- Table: public.eb_userstatus

-- DROP TABLE public.eb_userstatus;

CREATE TABLE public.eb_userstatus
(
    id integer NOT NULL DEFAULT nextval('eb_userstatus_id_seq'::regclass),
    createdby integer,
    createdat timestamp without time zone,
    userid integer,
    statusid integer,
    CONSTRAINT eb_userstatus_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_userstatus
    OWNER to postgres;

-- Index: eb_userstatus_id_idx

-- DROP INDEX public.eb_userstatus_id_idx;

CREATE INDEX eb_userstatus_id_idx
    ON public.eb_userstatus USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_userstatus_statusid_idx

-- DROP INDEX public.eb_userstatus_statusid_idx;

CREATE INDEX eb_userstatus_statusid_idx
    ON public.eb_userstatus USING btree
    (statusid)
    TABLESPACE pg_default;

-- Index: eb_userstatus_userid_idx

-- DROP INDEX public.eb_userstatus_userid_idx;

CREATE INDEX eb_userstatus_userid_idx
    ON public.eb_userstatus USING btree
    (userid)
    TABLESPACE pg_default;