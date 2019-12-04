-- Table: public.eb_usergroup

-- DROP TABLE public.eb_usergroup;

CREATE TABLE eb_usergroup
(
    id serial,
    name text,
    description text,
    eb_del char(1) NOT NULL DEFAULT 'F',
    CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id),
    CONSTRAINT eb_usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: eb_usergroup_eb_del_idx

-- DROP INDEX public.eb_usergroup_eb_del_idx;

CREATE INDEX eb_usergroup_eb_del_idx
    ON eb_usergroup(eb_del);

-- Index: eb_usergroup_id_idx

-- DROP INDEX public.eb_usergroup_id_idx;

CREATE INDEX eb_usergroup_id_idx
    ON eb_usergroup(id);