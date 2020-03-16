CREATE TABLE eb_objects
(
	id integer auto_increment,
	obj_name text, 
	obj_type int,
	obj_cur_status int,
	obj_desc text,
	obj_tags text,
	owner_uid int,
	owner_ts datetime,
	display_name text,
	is_logenabled char(1) DEFAULT 'F',
	eb_del char(1) DEFAULT 'F',
    	is_public char(1) DEFAULT 'F',
	CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_objects_id_idx
    ON eb_objects(id);

CREATE INDEX eb_objects_type_idx
    ON eb_objects(obj_type);

  