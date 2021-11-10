-- Table: public.eb_userstatus

-- DROP TABLE public.eb_userstatus;

CREATE TABLE eb_userstatus
(
    id serial,
    createdby integer,
    createdat timestamp without time zone,
    userid integer,
    statusid integer,
    CONSTRAINT eb_userstatus_pkey PRIMARY KEY (id)
);


-- Index: eb_userstatus_id_idx

-- DROP INDEX public.eb_userstatus_id_idx;

CREATE INDEX eb_userstatus_id_idx
    ON eb_userstatus(id);

-- Index: eb_userstatus_statusid_idx

-- DROP INDEX public.eb_userstatus_statusid_idx;

CREATE INDEX eb_userstatus_statusid_idx
    ON eb_userstatus(statusid);

-- Index: eb_userstatus_userid_idx

-- DROP INDEX public.eb_userstatus_userid_idx;

CREATE INDEX eb_userstatus_userid_idx
    ON eb_userstatus(userid);