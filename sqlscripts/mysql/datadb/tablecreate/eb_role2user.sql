-- DROP TABLE eb_role2user;

CREATE TABLE eb_role2user
(
    id INT NOT NULL auto_increment,
    role_id INT,
    user_id INT,
    createdby INT,
    createdat timestamp,
    revokedby INT,
    revokedat timestamp,
    eb_del char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_role2user_eb_del_idx

-- DROP INDEX public.eb_role2user_eb_del_idx;

CREATE INDEX eb_role2user_eb_del_idx
    ON eb_role2user (eb_del);

-- Index: eb_role2user_id_idx

-- DROP INDEX public.eb_role2user_id_idx;

CREATE UNIQUE INDEX eb_role2user_id_idx
    ON eb_role2user (id);

-- Index: eb_role2user_role_id_idx

-- DROP INDEX public.eb_role2user_role_id_idx;

CREATE INDEX eb_role2user_role_id_idx
    ON eb_role2user (role_id);

-- Index: eb_role2user_user_id_idx

-- DROP INDEX public.eb_role2user_user_id_idx;

CREATE INDEX eb_role2user_user_id_idx
    ON eb_role2user (user_id);