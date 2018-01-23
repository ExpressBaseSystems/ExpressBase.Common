
CREATE TABLE eb_objects
(
    id integer NOT NULL,
    obj_name varchar(30),
    obj_type integer,
    obj_cur_status integer,
    obj_desc varchar(200),
    applicationid integer,
    obj_tags varchar(30),
    owner_uid integer,
    owner_ts timestamp,
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
);

CREATE TABLE eb_objects_relations
(
    dominant varchar(30),
    dependant varchar(30),
    id integer NOT NULL,
    eb_del char,
    removed_by integer,
    removed_at timestamp,
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id)
);

CREATE TABLE eb_applications
(
    id integer NOT NULL,
    application_name varchar(30),
    application_type varchar(20),
    description varchar(200),
    eb_del char DEFAULT 'F',
    app_icon varchar(20),
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id)
)

CREATE TABLE eb_objects2application
(
    app_id integer,
    id integer NOT NULL,
    obj_id integer,
    eb_del char DEFAULT 'F',
    removed_by integer,
    removed_at timestamp,
	CONSTRAINT eb_objects2application_pkey PRIMARY KEY (id)
);

CREATE TABLE eb_objects_status
(
    id integer NOT NULL,
    refid varchar(20),
    status integer,
    userid integer,
    ts timestamp,
    eb_obj_ver_id integer,
    changelog varchar(20),
    CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
);

CREATE TABLE eb_objects_ver
(
    id integer NOT NULL,
    eb_objects_id integer,
    obj_changelog varchar(300),
    commit_uid integer,
    commit_ts timestamp,
    obj_json varchar(50),
    refid varchar(100),
    version_num varchar(15),
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,
    working_mode char DEFAULT 'F',
    status_id integer,
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id)
);