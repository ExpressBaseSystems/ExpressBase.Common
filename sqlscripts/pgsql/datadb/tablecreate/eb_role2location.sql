-- Table: public.eb_role2location

-- DROP TABLE public.eb_role2location;

CREATE TABLE eb_role2location
(
    id serial,
    roleid integer,
    locationid integer,
    eb_del char(1) DEFAULT 'F',
    eb_createdby integer,
    eb_createdat timestamp without time zone,
    eb_revokedby integer,
    eb_revokedat timestamp without time zone,
	CONSTRAINT eb_role2location_pkey PRIMARY KEY (id)
);


-- Index: public.eb_role2location_id_idx

-- DROP INDEX public.eb_role2location_id_idx;

CREATE INDEX eb_role2location_id_idx
    ON eb_role2location(id);
	
-- Index: public.eb_role2location_roleid_idx

-- DROP INDEX public.eb_role2location_roleid_idx;

CREATE INDEX eb_role2location_roleid_idx
    ON eb_role2location(roleid);
	
-- Index: public.eb_role2location_locationid_idx

-- DROP INDEX public.eb_role2location_locationid_idx;

CREATE INDEX eb_role2location_locationid_idx
    ON eb_role2location(locationid);