-- Table: public.eb_objects_ver

-- DROP TABLE public.eb_objects_ver;

CREATE TABLE eb_objects_ver
(
    id serial,
    eb_objects_id integer,
    obj_changelog text,
    commit_uid integer,
    commit_ts timestamp without time zone,
    obj_json json,
    refid text,
    version_num text,
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,
    status_id integer,
    ver_num text,
    working_mode char(1) DEFAULT 'F',
	eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T' OR working_mode = 'F')
);


-- Index: eb_objects_ver_eb_objects_id_idx

-- DROP INDEX public.eb_objects_ver_eb_objects_id_idx;

CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON eb_objects_ver(eb_objects_id);

-- Index: eb_objects_ver_id_idx

-- DROP INDEX public.eb_objects_ver_id_idx;

CREATE INDEX eb_objects_ver_id_idx
    ON eb_objects_ver(id);

-- Index: eb_objects_ver_status_id_idx

-- DROP INDEX public.eb_objects_ver_status_id_idx;

CREATE INDEX eb_objects_ver_status_id_idx
    ON eb_objects_ver(status_id);