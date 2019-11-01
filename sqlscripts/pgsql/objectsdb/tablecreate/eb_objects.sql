-- Table: public.eb_objects

-- DROP TABLE public.eb_objects;

CREATE TABLE eb_objects
(
    id serial,
    obj_name text,
    obj_type integer,
    obj_cur_status integer,
    obj_desc text,
    applicationid integer,
    obj_tags text,
    owner_uid integer,
    owner_ts timestamp without time zone,
    display_name,
    is_logenabled char(1) DEFAULT 'F',
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
);


-- Index: eb_objects_applicationid_idx

-- DROP INDEX public.eb_objects_applicationid_idx;

CREATE INDEX eb_objects_applicationid_idx
    ON eb_objects(applicationid);

-- Index: eb_objects_id_idx

-- DROP INDEX public.eb_objects_id_idx;

CREATE UNIQUE INDEX eb_objects_id_idx
    ON eb_objects(id);

-- Index: eb_objects_type_idx

-- DROP INDEX public.eb_objects_type_idx;

CREATE INDEX eb_objects_type_idx
    ON eb_objects(obj_type);