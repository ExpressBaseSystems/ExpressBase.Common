-- Table: public.eb_objects_status

-- DROP TABLE public.eb_objects_status;

CREATE TABLE eb_objects_status
(
    id serial,
    refid text,
    status integer,
    uid integer,
    ts timestamp without time zone,
    eb_obj_ver_id integer,
    changelog text,
    CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);


-- Index: eb_objects_status_eb_obj_ver_id_idx

-- DROP INDEX public.eb_objects_status_eb_obj_ver_id_idx;

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
    ON eb_objects_status(eb_obj_ver_id);

-- Index: eb_objects_status_id_idx

-- DROP INDEX public.eb_objects_status_id_idx;

CREATE INDEX eb_objects_status_id_idx
    ON eb_objects_status(id);

-- Index: eb_objects_status_refid_id_idx

-- DROP INDEX public.eb_objects_status_refid_id_idx;

CREATE INDEX eb_objects_status_refid_id_idx
    ON eb_objects_status(refid);