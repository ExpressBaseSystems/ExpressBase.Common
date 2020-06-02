-- Table: public.eb_users

-- DROP TABLE public.eb_users;

CREATE TABLE eb_users
(
    id serial,
    email text,
    pwd text,
    firstname text,
    lastname text,
    middlename text,
    dob date,
    phnoprimary text,
    phnosecondary text,
    landline text,
    phextension text,    
    alternateemail text,	
    profileimg text,
    slackjson json,
    prolink text,
    loginattempts integer DEFAULT 1,
    socialid text,
    socialname text,
    fullname text,
    nickname text,
    sex text,
    fbid text,
    fbname text,
    preferencesjson text,
    createdby text,
    createdat text,
    statusid integer DEFAULT 0,
    hide text,
    eb_del  "char" DEFAULT 'F'::"char",
    dprefid integer DEFAULT 0,
	eb_data_id integer,
	eb_ver_id integer,
	eb_user_types_id integer DEFAULT 1,
	eb_created_by integer,
	eb_created_at timestamp without time zone,
	eb_lastmodified_by integer,
	eb_lastmodified_at timestamp without time zone,
    CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

 
-- Index: eb_users_eb_del_idx

-- DROP INDEX public.eb_users_eb_del_idx;

CREATE INDEX eb_users_eb_del_idx
    ON eb_users(eb_del);

-- Index: eb_users_email_idx

-- DROP INDEX public.eb_users_email_idx;

CREATE INDEX eb_users_email_idx
    ON eb_users(email);

-- Index: eb_users_id_idx

-- DROP INDEX public.eb_users_id_idx;

CREATE INDEX eb_users_id_idx
    ON eb_users(id);

-- Index: eb_users_pwd_idx

-- DROP INDEX public.eb_users_pwd_idx;

CREATE INDEX eb_users_pwd_idx
    ON eb_users(pwd);

-- Index: eb_users_statusid_idx

-- DROP INDEX public.eb_users_statusid_idx;

CREATE INDEX eb_users_statusid_idx
    ON eb_users(statusid);