-- DROP TABLE eb_user2usergroup;

CREATE TABLE eb_user2usergroup
(
    id INT NOT NULL auto_increment,
    userid INT,
    groupid INT,
    createdby INT,
    createdat timestamp ,
    revokedby INT,
    revokedat timestamp ,
    eb_del char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_user2usergroup_eb_del_idx

-- DROP INDEX eb_user2usergroup_eb_del_idx;

CREATE INDEX eb_user2usergroup_eb_del_idx
    ON eb_user2usergroup (eb_del);

-- Index: eb_user2usergroup_groupid_idx

-- DROP INDEX eb_user2usergroup_groupid_idx;

CREATE INDEX eb_user2usergroup_groupid_idx
    ON eb_user2usergroup (groupid);

-- Index: eb_user2usergroup_id_idx

-- DROP INDEX eb_user2usergroup_id_idx;

CREATE INDEX eb_user2usergroup_id_idx
    ON eb_user2usergroup (id);

-- Index: eb_user2usergroup_userid_idx

-- DROP INDEX eb_user2usergroup_userid_idx;

CREATE INDEX eb_user2usergroup_userid_idx
    ON eb_user2usergroup (userid);