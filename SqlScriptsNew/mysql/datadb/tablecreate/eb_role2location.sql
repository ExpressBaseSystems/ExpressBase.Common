CREATE TABLE eb_role2location
(
  id integer auto_increment,
  roleid integer,
  locationid integer,
  eb_del char(1) DEFAULT 'F',
  eb_createdby integer,
  eb_createdat datetime,
  eb_revokedby integer,
  eb_revokedat datetime,
  constraint eb_role2location_pkey primary key(id)
);

CREATE INDEX eb_role2location_id_idx
ON eb_role2location(id);

CREATE INDEX eb_role2location_roleid_idx
ON eb_role2location(roleid);

CREATE INDEX eb_role2location_locationid_idx
ON eb_role2location(locationid);
