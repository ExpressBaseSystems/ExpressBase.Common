CREATE TABLE eb_usersanonymous
(
  id integer NOT NULL auto_increment,
  fullname text,
  socialid varchar(100),
  email varchar(100),
  sex text,
  phoneno text,
  firstvisit datetime(4),
  lastvisit datetime(4),
  appid integer,
  totalvisits integer DEFAULT 1,
  ebuserid integer DEFAULT 1,
  modifiedby integer,
  modifiedat datetime,
  remarks text,
  ipaddress text,
  browser text,
  city text,
  region text,
  country text,
  latitude text,
  longitude text,
  timezone text,
  iplocationjson text,
  CONSTRAINT eb_usersprospective_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_usersanonymous_email_idx
ON eb_usersanonymous(email);
  
CREATE INDEX eb_usersanonymous_id_idx
ON eb_usersanonymous(id);
  
CREATE INDEX eb_usersanonymous_socialid_idx
ON eb_usersanonymous(socialid);