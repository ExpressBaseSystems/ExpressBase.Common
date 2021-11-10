CREATE TABLE eb_users
(
    id integer auto_increment,
    email varchar(320),
    pwd varchar(75),
    fullname text,
    nickname text,
    sex text,
    dob date,
    phnoprimary text,
    phnosecondary text,
    landline text,
    phextension text,
    alternateemail text,
    slackjson json,
    prolink text,
    loginattempts integer DEFAULT 1,    
    fbid text,
    fbname text,
    preferencesjson text,
    statusid integer DEFAULT 0,
    hide text,
    dprefid integer DEFAULT 0,
    eb_user_types_id integer DEFAULT 1,
    eb_del char  DEFAULT 'F',
    eb_ver_id integer,
    eb_data_id integer,
    eb_created_by integer,
    eb_created_at datetime,
    eb_lastmodified_by integer,
    eb_lastmodified_at datetime,
    firstname text,
    CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_users_id_idx
ON eb_users(id);

CREATE INDEX eb_users_eb_del_idx
    ON eb_users(eb_del);

CREATE INDEX eb_users_email_idx
    ON eb_users(email);

CREATE INDEX eb_users_pwd_idx
    ON eb_users(pwd);

CREATE INDEX eb_users_statusid_idx
    ON eb_users(statusid);