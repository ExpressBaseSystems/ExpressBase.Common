--SEQUENCE public.eb_role2location_id_seq

CREATE SEQUENCE public.eb_role2location_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_role2location_id_seq
    OWNER TO postgres;


-- Table: public.eb_role2location

-- DROP TABLE public.eb_role2location;

CREATE TABLE public.eb_role2location
(
    id integer NOT NULL DEFAULT nextval('eb_role2location_id_seq'::regclass),
    roleid integer,
    locationid integer,
    eb_del "char" DEFAULT 'F'::"char",
    eb_createdby integer,
    eb_createdat timestamp without time zone,
    eb_revokedby integer,
    eb_revokedat timestamp without time zone,
	CONSTRAINT eb_role2location_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2location
    OWNER to postgres;
	
-- Index: public.eb_role2location_id_idx

-- DROP INDEX public.eb_role2location_id_idx;

CREATE INDEX eb_role2location_id_idx
    ON public.eb_role2location USING btree
       (id)
    TABLESPACE pg_default;
	
-- Index: public.eb_role2location_roleid_idx

-- DROP INDEX public.eb_role2location_roleid_idx;

CREATE INDEX eb_role2location_roleid_idx
    ON public.eb_role2location USING btree
       (roleid)
    TABLESPACE pg_default;
	
-- Index: public.eb_role2location_locationid_idx

-- DROP INDEX public.eb_role2location_locationid_idx;

CREATE INDEX eb_role2location_locationid_idx
    ON public.eb_role2location USING btree
       (locationid)
    TABLESPACE pg_default;