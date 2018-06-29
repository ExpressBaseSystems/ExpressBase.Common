-- Table: eb_objects_status

-- DROP TABLE eb_objects_status;

CREATE TABLE eb_objects_status
(
    id integer NOT NULL AUTO_INCREMENT,
    refid varchar(100) ,
    status integer,
    uid integer,
    ts timestamp,
    eb_obj_ver_id integer,
    changelog text,
    CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);

-- Index: eb_objects_status_eb_obj_ver_id_idx

-- ALTER TABLE eb_objects_status DROP INDEX eb_objects_status_eb_obj_ver_id_idx;

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
    ON eb_objects_status(eb_obj_ver_id);

-- Index: eb_objects_status_id_idx

-- ALTER TABLE eb_objects_status DROP INDEX eb_objects_status_id_idx;

CREATE INDEX eb_objects_status_id_idx
    ON eb_objects_status(id);

-- Index: eb_objects_status_refid_id_idx

-- ALTER TABLE eb_objects_status DROP INDEX eb_objects_status_refid_id_idx;

CREATE INDEX eb_objects_status_refid_id_idx
    ON eb_objects_status(refid);