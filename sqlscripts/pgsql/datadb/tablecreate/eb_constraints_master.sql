-- Table: public.eb_constraints_master

-- DROP TABLE public.eb_constraints_master;

CREATE TABLE eb_constraints_master
(
    id serial,
    key_id integer,
    key_type integer,
    description text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_constraints_master_pkey PRIMARY KEY (id)
);

	
-- Index: eb_constraints_master_id_idx

-- DROP INDEX public.eb_constraints_master_id_idx;

CREATE INDEX eb_constraints_master_id_idx
    ON eb_constraints_master(id);