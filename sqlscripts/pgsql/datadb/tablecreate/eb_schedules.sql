-- Table: public.eb_schedules

-- DROP TABLE public.eb_schedules;

CREATE TABLE eb_schedules
(
    id serial,
    task json,
    created_by integer,
    created_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F',
    jobkey text,
    triggerkey text,
    status numeric,
    obj_id numeric,
    name text,
	CONSTRAINT eb_schedules_pkey PRIMARY KEY (id)
);

	
-- Index: eb_schedules_id_idx

-- DROP INDEX public.eb_schedules_id_idx;

CREATE INDEX eb_schedules_id_idx
    ON eb_schedules(id);
