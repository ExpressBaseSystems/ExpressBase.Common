-- DROP TABLE eb_role2role;

CREATE TABLE eb_role2role
(
    id INT NOT NULL auto_increment,
    role1_id INT,
    role2_id INT,
    createdby INT,
    createdat timestamp ,
    revokedby INT,
    revokedat timestamp ,
    eb_del char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_role2role_eb_del_idx

-- DROP INDEX eb_role2role_eb_del_idx;

CREATE INDEX eb_role2role_eb_del_idx
    ON eb_role2role (eb_del);

-- Index: eb_role2role_id_idx

-- DROP INDEX eb_role2role_id_idx;

CREATE UNIQUE INDEX eb_role2role_id_idx
    ON eb_role2role (id);

-- Index: eb_role2role_role1_id_idx

-- DROP INDEX eb_role2role_role1_id_idx;

CREATE INDEX eb_role2role_role1_id_idx
    ON eb_role2role (role1_id);