CREATE SEQUENCE eb_objects_status_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects_status
(
    id int default (NEXT VALUE FOR eb_objects_status_id_seq),
    refid varchar(max),
    status integer,
    uid integer,
    ts datetime,
    eb_obj_ver_id integer,
    changelog varchar(max),
    CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
    ON eb_objects_status(eb_obj_ver_id);

CREATE INDEX eb_objects_status_id_idx
    ON eb_objects_status(id);

