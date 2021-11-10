CREATE SEQUENCE eb_objects_ver_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects_ver
(
    id int default (NEXT VALUE FOR eb_objects_ver_id_seq),
    eb_objects_id integer,
    obj_changelog varchar(max),
    commit_uid integer,
    commit_ts datetime,
    obj_json nvarchar(max),
    refid varchar(max),
    version_num varchar(max),
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,   
    status_id integer,
    ver_num varchar(max),
    working_mode char DEFAULT 'F',
    eb_del char DEFAULT 'F',
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_ver_working_mode_check CHECK (working_mode = 'T' OR working_mode = 'F')
);



CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON eb_objects_ver(eb_objects_id);

CREATE INDEX eb_objects_ver_id_idx
    ON eb_objects_ver(id);


CREATE INDEX eb_objects_ver_status_id_idx
    ON eb_objects_ver(status_id);