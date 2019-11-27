-- Table: public.eb_role2permission

-- DROP TABLE public.eb_role2permission;

CREATE TABLE eb_role2permission
(
    id serial,
    role_id integer,
    permissionname text,
    createdby integer,
    createdat timestamp without time zone,
    obj_id integer,
    op_id integer,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del char(1) NOT NULL DEFAULT 'F',
    CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_role2permission_eb_del_idx

-- DROP INDEX public.eb_role2permission_eb_del_idx;

CREATE INDEX eb_role2permission_eb_del_idx
    ON eb_role2permission(eb_del);

-- Index: eb_role2permission_role_id_idx

-- DROP INDEX public.eb_role2permission_role_id_idx;

CREATE INDEX eb_role2permission_role_id_idx
    ON eb_role2permission(role_id);

-- Index: public.eb_role2permission_id_idx

-- DROP INDEX public.eb_role2permission_id_idx;

CREATE INDEX eb_role2permission_id_idx
    ON eb_role2permission(id);

