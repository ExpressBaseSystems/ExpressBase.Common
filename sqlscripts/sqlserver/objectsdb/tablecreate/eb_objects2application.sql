CREATE SEQUENCE eb_objects2application_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects2application
(
    id int default (NEXT VALUE FOR eb_objects2application_id_seq),
    app_id integer,
    obj_id integer,    
    removed_by integer,
    removed_at datetime,
    eb_del char DEFAULT 'F',
    CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_objects2application_app_id_idx
    ON eb_objects2application(app_id);
	
CREATE INDEX eb_objects2application_eb_del_idx
    ON eb_objects2application(eb_del);

CREATE INDEX eb_objects2application_id_idx
    ON eb_objects2application(id);

CREATE INDEX eb_objects2application_obj_id_idx
    ON eb_objects2application(obj_id);