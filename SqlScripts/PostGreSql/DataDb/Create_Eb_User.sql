
-- Table: public.eb_role2role

-- DROP TABLE public.eb_role2role;

CREATE TABLE public.eb_role2role
(
    id integer NOT NULL DEFAULT nextval('eb_role2role_id_seq'::regclass),
    role1_id integer,
    role2_id integer,
    eb_del boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2role
    OWNER to postgres;

-- Index: eb_role2role_id_idx

-- DROP INDEX public.eb_role2role_id_idx;


--........................................................................................................



-- Table: public.eb_role2permission

-- DROP TABLE public.eb_role2permission;

CREATE TABLE public.eb_role2permission
(
    id integer NOT NULL DEFAULT nextval('eb_role2permission_id_seq'::regclass),
    role_id integer,
    eb_del boolean DEFAULT false,
    permissionname text COLLATE pg_catalog."default",
    createdby integer,
    createdat timestamp without time zone,
    obj_id integer,
    op_id integer,
    revokedby integer,
    revokedat timestamp without time zone,
    CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2permission
    OWNER to postgres;
	

--....................................................................................................




-- Table: public.eb_role2user

-- DROP TABLE public.eb_role2user;

CREATE TABLE public.eb_role2user
(
    id integer NOT NULL DEFAULT nextval('eb_role2user_id_seq'::regclass),
    role_id integer,
    user_id integer,
    eb_del boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2user
    OWNER to postgres;

-- Index: eb_role2user_id_idx

-- DROP INDEX public.eb_role2user_id_idx;


	
--.......................................................................................................


-- Table: public.eb_roles

-- DROP TABLE public.eb_roles;

CREATE TABLE public.eb_roles
(
    id integer NOT NULL DEFAULT nextval('eb_roles_id_seq'::regclass),
    role_name text COLLATE pg_catalog."default" NOT NULL,
    eb_del boolean,
    applicationname text COLLATE pg_catalog."default",
    applicationid integer,
    description text COLLATE pg_catalog."default",
    CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_rolename_unique UNIQUE (role_name)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_roles
    OWNER to postgres;

-- Index: eb_roles_id_idx

-- DROP INDEX public.eb_roles_id_idx;


	
--...................................................................................................


-- Table: public.eb_user2usergroup

-- DROP TABLE public.eb_user2usergroup;

CREATE TABLE public.eb_user2usergroup
(
    id integer NOT NULL DEFAULT nextval('eb_user2usergroup_id_seq'::regclass),
    userid integer,
    groupid integer,
    eb_del boolean DEFAULT false,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_user2usergroup
    OWNER to postgres;
	

	
--........................................................................................................


-- Table: public.eb_usergroup

-- DROP TABLE public.eb_usergroup;

CREATE TABLE public.eb_usergroup
(
    id integer NOT NULL DEFAULT nextval('eb_usergroup_id_seq'::regclass),
    name text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    eb_del boolean,
    CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_usergroup
    OWNER to postgres;
	

	
--.......................................................................................................

-- Table: public.eb_users

-- DROP TABLE public.eb_users;

CREATE TABLE public.eb_users
(
    id integer NOT NULL DEFAULT nextval('eb_users_id_seq'::regclass),
    email text COLLATE pg_catalog."default",
    pwd text COLLATE pg_catalog."default",
    eb_del boolean DEFAULT false,
    firstname text COLLATE pg_catalog."default",
    lastname text COLLATE pg_catalog."default",
    middlename text COLLATE pg_catalog."default",
    dob date,
    phnoprimary text COLLATE pg_catalog."default",
    phnosecondary text COLLATE pg_catalog."default",
    landline text COLLATE pg_catalog."default",
    extension text COLLATE pg_catalog."default",
    locale text COLLATE pg_catalog."default",
    alternateemail text COLLATE pg_catalog."default",
    dateformat text COLLATE pg_catalog."default" DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" DEFAULT '0,000.00'::text,
    timezoneabbre text COLLATE pg_catalog."default",
    timezonefull text COLLATE pg_catalog."default",
    profileimg text COLLATE pg_catalog."default",
    slackjson json,
    prolink text COLLATE pg_catalog."default",
    loginattempts integer DEFAULT 1,
    socialid text COLLATE pg_catalog."default",
    CONSTRAINT eb_users_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_users
    OWNER to postgres;

-- Index: eb_users_email_idx

-- DROP INDEX public.eb_users_email_idx;

