CREATE TABLE eb_users
(
  id integer NOT NULL auto_increment,
  email text,
  pwd text,
  eb_del1 boolean DEFAULT false,
  firstname varchar(25),
  lastname text,
  middlename text,
  dob date,
  phnoprimary text,
  phnosecondary text,
  landline text,
  phextension text,
  locale text,
  alternateemail text,
  dateformat varchar(20) DEFAULT 'DD/MM/YYYY',
  timezone varchar(25) DEFAULT 'UTC+05:30',
  numformat varchar(25) DEFAULT '0,000.00',
  timezoneabbre text,
  timezonefull text,
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
  CONSTRAINT eb_users_pkey PRIMARY KEY (id),
  CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_users_idx
ON eb_users(id) 
USING btree;

CREATE INDEX eb_users_firstname_idx
ON eb_users(firstname) 
USING btree;