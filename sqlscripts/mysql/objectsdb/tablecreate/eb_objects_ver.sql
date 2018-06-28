-- Table: eb_objects_ver

-- DROP TABLE eb_objects_ver;

CREATE TABLE eb_objects_ver
(
    id integer NOT NULL AUTO_INCREMENT,
    eb_objects_id integer,
    obj_changelog text,
    commit_uid integer,
    commit_ts timestamp,
    obj_json json,
    refid text,
    version_num text,
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,
    working_mode1 boolean DEFAULT false,
    status_id integer,
    ver_num text,
    working_mode char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T' OR working_mode = 'F')
);

-- Index: eb_objects_ver_eb_objects_id_idx

-- ALTER TABLE eb_objects_ver DROP INDEX eb_objects_ver_eb_objects_id_idx;

CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON eb_objects_ver(eb_objects_id);

-- Index: eb_objects_ver_id_idx

-- ALTER TABLE eb_objects_ver DROP INDEX eb_objects_ver_id_idx;

CREATE INDEX eb_objects_ver_id_idx
    ON eb_objects_ver(id);

-- Index: eb_objects_ver_status_id_idx

-- ALTER TABLE eb_objects_ver DROP INDEX eb_objects_ver_status_id_idx;

CREATE INDEX eb_objects_ver_status_id_idx
    ON eb_objects_ver(status_id);