CREATE UNIQUE INDEX IF NOT EXISTS eb_role2role_id_idx
    ON public.eb_role2role USING btree
    (id)
    TABLESPACE pg_default;
	
--.......................................................
CREATE UNIQUE INDEX IF NOT EXISTS  eb_role2permission_id_idx
    ON public.eb_role2permission USING btree
    (id)
    TABLESPACE pg_default;

--....................................
CREATE UNIQUE INDEX IF NOT EXISTS eb_role2user_id_idx
    ON public.eb_role2user USING btree
    (id)
    TABLESPACE pg_default;

--....................................
CREATE UNIQUE INDEX IF NOT EXISTS eb_roles_id_idx
    ON public.eb_roles USING btree
    (id)
    TABLESPACE pg_default;

--.........................
CREATE UNIQUE INDEX IF NOT EXISTS eb_user2usergroup_id_idx
    ON public.eb_user2usergroup USING btree
    (id)
    TABLESPACE pg_default;

	CREATE UNIQUE INDEX IF NOT EXISTS eb_usergroup_id_idx
    ON public.eb_usergroup USING btree
    (id)
    TABLESPACE pg_default;

	CREATE INDEX IF NOT EXISTS eb_users_email_idx
    ON public.eb_users USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: eb_users_id_idx

-- DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX IF NOT EXISTS eb_users_id_idx
    ON public.eb_users USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_users_pwd_idx

-- DROP INDEX public.eb_users_pwd_idx;

CREATE INDEX IF NOT EXISTS eb_users_pwd_idx
    ON public.eb_users USING btree
    (pwd COLLATE pg_catalog."default")
    TABLESPACE pg_default;