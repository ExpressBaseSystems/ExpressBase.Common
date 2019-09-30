-- Table: public.eb_userstatus

-- DROP TABLE public.eb_userstatus;

CREATE TABLE public.eb_userstatus
(
    id serial,
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