-- DROP TABLE eb_userstatus;

CREATE TABLE eb_userstatus
(
    id INT NOT NULL auto_increment,
    createdby INT,
    createdat DATE,
    userid INT,
    statusid INT,
    PRIMARY KEY (id)
);

-- Index: eb_userstatus_id_idx

-- DROP INDEX eb_userstatus_id_idx;

CREATE INDEX eb_userstatus_id_idx
    ON eb_userstatus (id);

-- Index: eb_userstatus_statusid_idx

-- DROP INDEX eb_userstatus_statusid_idx;

CREATE INDEX eb_userstatus_statusid_idx
    ON eb_userstatus (statusid);

-- Index: eb_userstatus_userid_idx

-- DROP INDEX eb_userstatus_userid_idx;

CREATE INDEX eb_userstatus_userid_idx
    ON eb_userstatus (userid);