CREATE TABLE eb_users
(
  id integer auto_increment,
  email varchar(320),
  pwd varchar(75),
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
  statusid integer,
  hide text,
  eb_del char(1) DEFAULT 'F',
  dprefid integer DEFAULT 0,
  eb_data_id integer,
  eb_ver_id integer,
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

