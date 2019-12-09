CREATE SEQUENCE eb_role2role_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_role2role
(
    id int default(NEXT VALUE FOR eb_role2role_id_seq) primary key,
    role1_id int,
    role2_id int,
    createdby int,
    createdat datetime2(6),
    revokedby int,
    revokedat datetime2(6),
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_role2role_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_role2role_id_idx ON eb_role2role(id);
CREATE INDEX eb_role2permission_role_id_idx ON eb_role2role(role1_id);
CREATE INDEX eb_role2role_role1_id_idx ON eb_role2role(eb_del);