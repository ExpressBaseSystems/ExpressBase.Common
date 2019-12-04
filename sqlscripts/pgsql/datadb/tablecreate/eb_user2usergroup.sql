-- Table: public.eb_user2usergroup

-- DROP TABLE public.eb_user2usergroup;

CREATE TABLE eb_user2usergroup
(
    id serial,
    userid integer,
    groupid integer,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del char(1) NOT NULL DEFAULT 'F',
    CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id),
    CONSTRAINT eb_user2usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: eb_user2usergroup_eb_del_idx

-- DROP INDEX public.eb_user2usergroup_eb_del_idx;

CREATE INDEX eb_user2usergroup_eb_del_idx
    ON eb_user2usergroup(eb_del);

-- Index: eb_user2usergroup_groupid_idx

-- DROP INDEX public.eb_user2usergroup_groupid_idx;

CREATE INDEX eb_user2usergroup_groupid_idx
    ON eb_user2usergroup(groupid);

-- Index: eb_user2usergroup_id_idx

-- DROP INDEX public.eb_user2usergroup_id_idx;

CREATE INDEX eb_user2usergroup_id_idx
    ON eb_user2usergroup(id);

-- Index: eb_user2usergroup_userid_idx

-- DROP INDEX public.eb_user2usergroup_userid_idx;

CREATE INDEX eb_user2usergroup_userid_idx
    ON eb_user2usergroup(userid);