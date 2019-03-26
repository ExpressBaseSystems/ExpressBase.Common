CREATE TABLE eb_userstatus
(
  id integer NOT NULL auto_increment,
  createdby integer,
  createdat timestamp,
  userid integer,
  statusid integer,
  CONSTRAINT eb_userstatus_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_userstatus_idx
ON eb_userstatus(id) 
USING btree;

CREATE INDEX eb_userstatus_userid_idx
ON eb_userstatus(userid) 
USING btree;
