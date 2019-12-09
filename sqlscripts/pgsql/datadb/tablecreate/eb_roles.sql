-- Table: public.eb_roles

-- DROP TABLE public.eb_roles;

CREATE TABLE eb_roles
(
    id serial,
    role_name text NOT NULL,
    applicationname text,
    applicationid integer,
    description text,
    eb_del char(1) DEFAULT 'F',
    is_anonymous char(1) DEFAULT 'F',
    CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_rolename_unique UNIQUE (role_name),
    CONSTRAINT eb_roles_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

	
ALTER SEQUENCE 	eb_roles_id_seq INCREMENT 1 RESTART 101 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;
	

-- Index: eb_roles_eb_del_idx

-- DROP INDEX public.eb_roles_eb_del_idx;

CREATE INDEX eb_roles_eb_del_idx
    ON eb_roles(eb_del);

-- Index: eb_roles_id_idx

-- DROP INDEX public.eb_roles_id_idx;

CREATE INDEX eb_roles_id_idx
    ON eb_roles(id);


