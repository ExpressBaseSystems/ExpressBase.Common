CREATE TABLE eb_role2location
(
  id integer NOT NULL auto_increment,
  roleid integer,
  locationid integer,
  eb_del char DEFAULT 'F',
  eb_createdby integer,
  eb_createdat timestamp DEFAULT CURRENT_TIMESTAMP,
  eb_revokedby integer,
  eb_revokedat timestamp DEFAULT CURRENT_TIMESTAMP,
  constraint eb_role2location_pkey primary key(id)
);

CREATE INDEX eb_role2location_idx
ON eb_role2location(id) 
USING btree;

CREATE INDEX eb_role2location_roleid_idx
ON eb_role2location(roleid) 
USING btree;

CREATE INDEX eb_role2location_locationid_idx
ON eb_role2location(locationid) 
USING btree;
