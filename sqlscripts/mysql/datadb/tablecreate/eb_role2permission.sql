-- DROP TABLE eb_role2permission;

CREATE TABLE eb_role2permission
(
    id INT NOT NULL auto_increment,
    role_id INT,
    permissionname varchar(50),
    createdby INT,
    createdat timestamp,
    obj_id INT,
    op_id INT,
    revokedby INT,
    revokedat timestamp,
    permissionname_backup varchar(50),
    eb_del char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_role2permission_eb_del_idx

-- DROP INDEX eb_role2permission_eb_del_idx;

CREATE INDEX eb_role2permission_eb_del_idx
    ON eb_role2permission (eb_del);

-- Index: eb_role2permission_role_id_idx

-- DROP INDEX eb_role2permission_role_id_idx;

CREATE INDEX eb_role2permission_role_id_idx
    ON eb_role2permission (role_id);

-- Index: public.eb_role2permission_id_idx

-- DROP INDEX eb_role2permission_id_idx;

CREATE INDEX eb_role2permission_id_idx
    ON eb_role2permission (id);
