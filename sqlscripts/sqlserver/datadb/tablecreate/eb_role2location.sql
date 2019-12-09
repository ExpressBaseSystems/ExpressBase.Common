CREATE SEQUENCE eb_role2location_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_role2location
(
    id int default(NEXT VALUE FOR eb_role2location_id_seq) primary key,
    roleid int,
    locationid int,
    eb_del char DEFAULT 'F',
    eb_createdby int,
    eb_createdat datetime2(6),
    eb_revokedby int,
    eb_revokedat datetime2(6)
);

CREATE INDEX eb_role2location_id_idx ON eb_role2location(id);
CREATE INDEX eb_role2location_roleid_idx ON eb_role2location(roleid);
CREATE INDEX eb_role2location_locationid_idx ON eb_role2location(locationid);