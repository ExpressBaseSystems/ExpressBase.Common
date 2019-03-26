CREATE TABLE eb_usersanonymous
(
  id integer NOT NULL auto_increment,
  fullname text,
  socialid varchar(50),
  email varchar(50),
  sex text,
  phoneno text,
  firstvisit timestamp DEFAULT CURRENT_TIMESTAMP,
  lastvisit timestamp DEFAULT CURRENT_TIMESTAMP,
  appid integer,
  totalvisits integer DEFAULT 1,
  ebuserid integer DEFAULT 1,
  modifiedby integer,
  modifiedat timestamp DEFAULT CURRENT_TIMESTAMP,
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
ON eb_usersanonymous(email)
USING btree;
  
CREATE INDEX eb_usersanonymous_id_idx
ON eb_usersanonymous(id)
USING btree;
  
CREATE INDEX eb_usersanonymous_socialid_idx
ON eb_usersanonymous(socialid)
USING btree;