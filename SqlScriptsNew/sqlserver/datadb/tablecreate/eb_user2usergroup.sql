CREATE SEQUENCE eb_user2usergroup_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_user2usergroup
(
    id int default(NEXT VALUE FOR eb_user2usergroup_id_seq) primary key,
    userid int,
    groupid int,
    createdby int,
    createdat datetime2(6),
    revokedby int,
    revokedat datetime2(6),
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_user2usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_user2usergroup_id_idx ON eb_user2usergroup(id);
CREATE INDEX eb_user2usergroup_eb_del_idx ON eb_user2usergroup(eb_del);
CREATE INDEX eb_user2usergroup_groupid_idx ON eb_user2usergroup(groupid);
CREATE INDEX eb_user2usergroup_userid_idx ON eb_user2usergroup(userid);