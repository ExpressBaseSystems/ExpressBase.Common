CREATE SEQUENCE eb_objects_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects
(
    id int default (NEXT VALUE FOR eb_objects_id_seq),
    obj_name varchar(max),
    obj_type integer,
    obj_cur_status integer,
    obj_desc varchar(max),
    obj_tags varchar(max),
    owner_uid integer,
    owner_ts datetime,	
    display_name varchar(max),
    is_logenabled char DEFAULT 'F',
    eb_del char DEFAULT 'F',
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_objects_id_idx
    ON eb_objects(id);

CREATE INDEX eb_objects_type_idx
    ON eb_objects(obj_type);