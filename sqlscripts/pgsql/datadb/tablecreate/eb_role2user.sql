-- Table: public.eb_role2user

-- DROP TABLE public.eb_role2user;

CREATE TABLE eb_role2user
(
    id serial,
    role_id integer,
    user_id integer,
    createdby integer,
    createdat timestamp without time zone,
    revokedby integer,
    revokedat timestamp without time zone,
    eb_del  "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2user_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: eb_role2user_eb_del_idx

-- DROP INDEX public.eb_role2user_eb_del_idx;

CREATE INDEX eb_role2user_eb_del_idx
    ON eb_role2user(eb_del);

-- Index: eb_role2user_id_idx

-- DROP INDEX public.eb_role2user_id_idx;

CREATE INDEX eb_role2user_id_idx
    ON eb_role2user(id);

-- Index: eb_role2user_role_id_idx

-- DROP INDEX public.eb_role2user_role_id_idx;

CREATE INDEX eb_role2user_role_id_idx
    ON eb_role2user(role_id);

-- Index: eb_role2user_user_id_idx

-- DROP INDEX public.eb_role2user_user_id_idx;

CREATE INDEX eb_role2user_user_id_idx
    ON eb_role2user(user_id);