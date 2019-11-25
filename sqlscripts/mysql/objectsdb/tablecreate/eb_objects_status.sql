CREATE TABLE eb_objects_status
(
	id integer NOT NULL auto_increment,
	refid varchar(200),
	status integer,
	uid integer,
	ts datetime,
	eb_obj_ver_id integer,
	changelog text,
	CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
    ON eb_objects_status(eb_obj_ver_id);

CREATE INDEX eb_objects_status_id_idx
    ON eb_objects_status(id);

CREATE INDEX eb_objects_status_refid_id_idx
    ON eb_objects_status(refid);