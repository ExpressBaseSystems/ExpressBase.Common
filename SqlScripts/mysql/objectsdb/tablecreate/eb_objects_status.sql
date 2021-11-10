CREATE TABLE eb_objects_status
(
	id integer auto_increment,	
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

