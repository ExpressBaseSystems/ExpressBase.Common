-- Table: public.eb_role2role

-- DROP TABLE public.eb_role2role;

CREATE TABLE eb_role2role
(
    id serial,
    role1_id integer,
    role2_id integer,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del  "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2role_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: eb_role2role_eb_del_idx

-- DROP INDEX public.eb_role2role_eb_del_idx;

CREATE INDEX eb_role2role_eb_del_idx
    ON eb_role2role(eb_del);

-- Index: eb_role2role_id_idx

-- DROP INDEX public.eb_role2role_id_idx;

CREATE INDEX eb_role2role_id_idx
    ON eb_role2role(id);

-- Index: eb_role2role_role1_id_idx

-- DROP INDEX public.eb_role2role_role1_id_idx;

CREATE INDEX eb_role2role_role1_id_idx
    ON eb_role2role(role1_id);