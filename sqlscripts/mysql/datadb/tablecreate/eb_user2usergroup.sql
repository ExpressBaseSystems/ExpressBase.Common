CREATE TABLE eb_user2usergroup
(
  id integer NOT NULL auto_increment,
  userid integer,
  groupid integer,
  eb_del1 boolean DEFAULT false,
  createdby integer,
  createdat timestamp DEFAULT CURRENT_TIMESTAMP,
  revokedby integer,
  revokedat timestamp DEFAULT CURRENT_TIMESTAMP,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id),
  CONSTRAINT eb_user2usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_user2usergroup_eb_del_idx
ON eb_user2usergroup(eb_del)
USING btree;
  
CREATE INDEX eb_user2usergroup_groupid_idx
ON eb_user2usergroup(groupid)
USING btree;

CREATE INDEX eb_user2usergroup_id_idx
ON eb_user2usergroup(id)
USING btree;
    
CREATE INDEX eb_user2usergroup_userid_idx
ON eb_user2usergroup(userid)
USING btree;