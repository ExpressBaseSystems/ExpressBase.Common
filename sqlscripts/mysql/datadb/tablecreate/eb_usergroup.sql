-- DROP TABLE eb_usergroup;

CREATE TABLE eb_usergroup
(
    id integer NOT NULL auto_increment,
    name varchar(255),
    description varchar(255),
    eb_del char NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_usergroup_eb_del_idx

-- DROP INDEX eb_usergroup_eb_del_idx;

CREATE INDEX eb_usergroup_eb_del_idx
    ON eb_usergroup (eb_del);

-- Index: eb_usergroup_id_idx

-- DROP INDEX eb_usergroup_id_idx;

CREATE INDEX eb_usergroup_id_idx
    ON eb_usergroup (id);