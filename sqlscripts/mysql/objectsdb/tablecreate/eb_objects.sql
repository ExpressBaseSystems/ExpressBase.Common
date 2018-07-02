-- Table: eb_objects

-- DROP TABLE eb_objects;

CREATE TABLE eb_objects
(
    id integer NOT NULL AUTO_INCREMENT,
    obj_name text,
    obj_type integer,
    obj_cur_status integer,
    obj_desc text,
    applicationid integer,
    obj_tags text,
    owner_uid integer,
    owner_ts timestamp,
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
);

-- Index: eb_objects_applicationid_idx

-- ALTER TABLE eb_objects DROP INDEX eb_objects_applicationid_idx;

CREATE INDEX eb_objects_applicationid_idx
    ON eb_objects(applicationid);

-- Index: eb_objects_id_idx

-- ALTER TABLE eb_objects DROP INDEX eb_objects_id_idx;

CREATE UNIQUE INDEX eb_objects_id_idx
    ON eb_objects(id);

-- Index: eb_objects_type_idx

-- ALTER TABLE eb_objects DROP INDEX eb_objects_type_idx;

CREATE INDEX eb_objects_type_idx
    ON eb_objects(obj_type);