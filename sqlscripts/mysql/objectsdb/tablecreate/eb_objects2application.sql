-- Table: eb_objects2application

-- DROP TABLE eb_objects2application;

CREATE TABLE eb_objects2application
(
    app_id integer,
    id integer UNIQUE NOT NULL AUTO_INCREMENT,
    obj_id integer,
    eb_del1 boolean DEFAULT false,
    removed_by integer,
    removed_at timestamp,
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_objects2application_app_id_idx

-- ALTER TABLE eb_objects2application DROP INDEX eb_objects2application_app_id_idx;

CREATE INDEX eb_objects2application_app_id_idx
    ON eb_objects2application(app_id);

-- Index: eb_objects2application_eb_del_idx

-- ALTER TABLE eb_objects2application DROP INDEX eb_objects2application_eb_del_idx;

CREATE INDEX eb_objects2application_eb_del_idx
    ON eb_objects2application(eb_del);

-- Index: eb_objects2application_id_idx

-- ALTER TABLE eb_objects2application DROP INDEX eb_objects2application_id_idx;

CREATE INDEX eb_objects2application_id_idx
    ON eb_objects2application(id);

-- Index: eb_objects2application_obj_id_idx

-- ALTER TABLE eb_objects2application DROP INDEX eb_objects2application_obj_id_idx;

CREATE INDEX eb_objects2application_obj_id_idx
    ON eb_objects2application(obj_id);