CREATE SEQUENCE eb_userstatus_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_userstatus
(
    id int default(NEXT VALUE FOR eb_userstatus_id_seq) primary key,
    createdby int,
    createdat datetime2(6),
    userid int,
    statusid int
);
CREATE INDEX eb_userstatus_id_idx ON eb_userstatus(id);
CREATE INDEX eb_userstatus_statusid_idx ON eb_userstatus(statusid);
CREATE INDEX eb_userstatus_userid_idx ON eb_userstatus(userid);