CREATE TABLE eb_user2usergroup
(
  id integer auto_increment,
  userid integer,
  groupid integer,  
  createdby integer,
  createdat datetime,
  revokedby integer,
  revokedat datetime,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id),
  CONSTRAINT eb_user2usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_user2usergroup_eb_del_idx
ON eb_user2usergroup(eb_del);
  
CREATE INDEX eb_user2usergroup_groupid_idx
ON eb_user2usergroup(groupid);

CREATE INDEX eb_user2usergroup_id_idx
ON eb_user2usergroup(id);
    
CREATE INDEX eb_user2usergroup_userid_idx
ON eb_user2usergroup(userid);