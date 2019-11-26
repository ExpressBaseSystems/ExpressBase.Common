CREATE TABLE eb_userstatus
(
  id integer NOT NULL auto_increment,
  createdby integer,
  createdat datetime,
  userid integer,
  statusid integer,
  CONSTRAINT eb_userstatus_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_userstatus_id_idx
ON eb_userstatus(id);

CREATE INDEX eb_userstatus_userid_idx
ON eb_userstatus(userid);

CREATE INDEX eb_userstatus_statusid_idx
    ON eb_userstatus(statusid);
