CREATE SEQUENCE eb_role2permission_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_role2permission
(
    id int default(NEXT VALUE FOR eb_role2permission_id_seq) primary key,
    role_id int,
    permissionname varchar(max) ,
    createdby int,
    createdat datetime2(6),
    obj_id int,
    op_id int,
    revokedby int,
    revokedat datetime2(6),
    eb_del "char" NOT NULL DEFAULT 'F',
    CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_role2permission_id_idx ON eb_role2permission(id);
CREATE INDEX eb_role2permission_role_id_idx ON eb_role2permission(role_id);
CREATE INDEX eb_role2permission_eb_del_idx ON eb_role2permission(eb_del);