-- Table: public.eb_objects_ver

-- DROP TABLE public.eb_objects_ver;

CREATE TABLE public.eb_objects_ver
(
    id serial,
    eb_objects_id integer,
    obj_changelog text COLLATE pg_catalog."default",
    commit_uid integer,
    commit_ts timestamp without time zone,
    obj_json json,
    refid text COLLATE pg_catalog."default",
    version_num text COLLATE pg_catalog."default",
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,
    working_mode1 boolean DEFAULT false,
    status_id integer,
    ver_num text COLLATE pg_catalog."default",
    working_mode "char" NOT NULL DEFAULT 'F'::"char",
	eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T'::"char" OR working_mode = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_objects_ver_eb_objects_id_idx

-- DROP INDEX public.eb_objects_ver_eb_objects_id_idx;

CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON public.eb_objects_ver USING btree
    (eb_objects_id)
    TABLESPACE pg_default;

-- Index: eb_objects_ver_id_idx

-- DROP INDEX public.eb_objects_ver_id_idx;

CREATE INDEX eb_objects_ver_id_idx
    ON public.eb_objects_ver USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_objects_ver_status_id_idx

-- DROP INDEX public.eb_objects_ver_status_id_idx;

CREATE INDEX eb_objects_ver_status_id_idx
    ON public.eb_objects_ver USING btree
    (status_id)
    TABLESPACE pg_default;