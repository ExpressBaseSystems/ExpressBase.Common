-- Table: public.eb_objects

CREATE SEQUENCE IF NOT EXISTS eb_objects_id_seq START 1;
CREATE TABLE public.eb_objects
(
    id integer NOT NULL DEFAULT nextval('eb_objects_id_seq'::regclass),
    obj_name text COLLATE pg_catalog."default",
    obj_desc text COLLATE pg_catalog."default",
    obj_type integer,
    obj_last_ver_id integer,
    obj_cur_status integer,
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects
    OWNER to postgres;

-- Index: eb_objects_id_idx

-- DROP INDEX public.eb_objects_id_idx;

CREATE UNIQUE INDEX eb_objects_id_idx
    ON public.eb_objects USING btree
    (id)
    TABLESPACE pg_default;
-------------------------------------------------------------------------------------

-- Table: public.eb_operations

-- DROP TABLE public.eb_operations;
CREATE SEQUENCE IF NOT EXISTS eb_operations_id_seq START 1;
CREATE TABLE IF NOT EXISTS public.eb_operations
(
    id integer NOT NULL DEFAULT nextval('eb_operations_id_seq'::regclass),
    operation_name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT eb_operations_id_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_operations
    OWNER to postgres;

-- Index: eb_operations_id_idx


CREATE UNIQUE INDEX eb_operations_id_idx
    ON public.eb_operations USING btree
    (id)
    TABLESPACE pg_default;

----------------------------------------------------------------------------------------------

	-- Table: public.eb_permissions



CREATE SEQUENCE IF NOT EXISTS eb_permissions_id_seq START 1;

CREATE TABLE IF NOT EXISTS public.eb_permissions
(
    id integer NOT NULL DEFAULT nextval('eb_permissions_id_seq'::regclass),
    object_id integer,
    operation_id integer,
    CONSTRAINT eb_permissions_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_permissions_object_id_fkey FOREIGN KEY (object_id)
        REFERENCES public.eb_objects (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT eb_permissions_operation_id_fkey FOREIGN KEY (operation_id)
        REFERENCES public.eb_operations (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_permissions
    OWNER to postgres;

-- Index: eb_permissions_id_idx


CREATE UNIQUE INDEX eb_permissions_id_idx
    ON public.eb_permissions USING btree
    (id)
    TABLESPACE pg_default;

	--------------------------------------------------------------------------------------------------

	-- Table: public.eb_roles

CREATE SEQUENCE IF NOT EXISTS eb_roles_id_seq START 100;

CREATE TABLE IF NOT EXISTS public.eb_roles
(
    id integer NOT NULL DEFAULT nextval('eb_roles_id_seq'::regclass),
    role_name text COLLATE pg_catalog."default" NOT NULL,
    eb_del boolean,
    CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_roles
    OWNER to postgres;

-- Index: eb_roles_id_idx


CREATE UNIQUE INDEX eb_roles_id_idx
    ON public.eb_roles USING btree
    (id)
    TABLESPACE pg_default;


	---------------------------------------------------------------------------------------

	-- Table: public.eb_permission2role

CREATE SEQUENCE IF NOT EXISTS eb_permission2role_id_seq START 1;

CREATE TABLE IF NOT EXISTS public.eb_permission2role
(
    id integer NOT NULL DEFAULT nextval('eb_permission2role_id_seq'::regclass),
    permission_id integer,
    role_id integer,
    eb_del boolean,
    CONSTRAINT eb_permission2role_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_permission2role_permission_id_fkey FOREIGN KEY (permission_id)
        REFERENCES public.eb_permissions (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT eb_permission2role_role_id_fkey FOREIGN KEY (role_id)
        REFERENCES public.eb_roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_permission2role
    OWNER to postgres;

-- Index: eb_permission2role_id_idx


CREATE UNIQUE INDEX eb_permission2role_id_idx
    ON public.eb_permission2role USING btree
    (id)
    TABLESPACE pg_default;

	

	-----------------------------------------------------------------------------------------------

	-- Table: public.eb_role2role

CREATE SEQUENCE IF NOT EXISTS eb_role2role_id_seq START 1;

CREATE TABLE IF NOT EXISTS public.eb_role2role
(
    id integer NOT NULL DEFAULT nextval('eb_role2role_id_seq'::regclass),
    role1_id integer,
    role2_id integer,
    eb_del boolean,
    CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_role2role_role1_id_fkey FOREIGN KEY (role1_id)
        REFERENCES public.eb_roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT eb_role2role_role2_id_fkey FOREIGN KEY (role2_id)
        REFERENCES public.eb_roles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2role
    OWNER to postgres;

-- Index: eb_role2role_id_idx


CREATE UNIQUE INDEX eb_role2role_id_idx
    ON public.eb_role2role USING btree
    (id)
    TABLESPACE pg_default;


-- Table: public.eb_objects_ver


CREATE SEQUENCE IF NOT EXISTS eb_objects_ver_id_seq START 1;
CREATE TABLE public.eb_objects_ver
(
    id integer NOT NULL DEFAULT nextval('eb_objects_ver_id_seq'::regclass),
    eb_objects_id integer,
    ver_num integer,
    obj_bytea bytea,
    changelog text COLLATE pg_catalog."default",
    commit_uid integer,
    commit_ts timestamp without time zone
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_ver
    OWNER to postgres;

  -- Index: eb_objects_ver_id_idx 
    
    CREATE UNIQUE INDEX eb_objects_ver_id_idx
    ON public.eb_objects_ver USING btree
    (id)
    TABLESPACE pg_default;

	-- Table: public.eb_objects_relations

CREATE SEQUENCE IF NOT EXISTS eb_objects_relations_id_seq START 1;

CREATE TABLE public.eb_objects_relations
(
    id integer NOT NULL DEFAULT nextval('eb_objects_relations_id_seq'::regclass),
    dominant integer,
    dependant integer,
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_relations
    OWNER to postgres;
    
    -- Index: eb_objects_relations_id_idx 
    
   CREATE UNIQUE INDEX eb_objects_relations_id_idx
    ON public.eb_objects_relations USING btree
    (id)
    TABLESPACE pg_default;

	-- Table: public.eb_objectstatus
	
CREATE SEQUENCE IF NOT EXISTS eb_objectstatus_id_seq START 1;

CREATE TABLE public.eb_objectstatus
(
    id integer NOT NULL DEFAULT nextval('eb_objectstatus_id_seq'::regclass),
    eb_objectid integer,
    status integer,
    remarks text COLLATE pg_catalog."default",
    uid integer,
    ts timestamp without time zone,
    CONSTRAINT eb_objectstatus_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objectstatus
    OWNER to postgres;

	  -- Index: eb_objectstatus_id_idx 
    
CREATE UNIQUE INDEX eb_objectstatus_id_idx     ON public.eb_objectstatus USING btree    (id)    TABLESPACE pg_default;

	-- INSERT COMMANDS--

	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(1,'Eb_Admin',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(2,'Eb_ReadOnlyUser',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(3,'Account_Owner',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(4,'Account_Admin',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(5,'Account_Developer',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(6,'Account_Tester',false);
	INSERT INTO eb_roles (id,role_name,eb_del) VALUES(7,'Account_PM',false);


CREATE OR REPLACE FUNCTION getallroles( uname text,pwd text )
RETURNS TABLE (role_id integer, role_name text) AS $$
BEGIN
	RETURN QUERY
SELECT 
    _roles.id,
    _roles.role_name 
FROM 
    eb_roles _roles
WHERE 
    id = ANY(
				(SELECT _r2user.role_id FROM eb_role2user _r2user WHERE _r2user.user_id = ANY (SELECT _usertbl.id FROM eb_users _usertbl WHERE _usertbl.email= $1 AND _usertbl.pwd = $2))
                UNION ALL
				(WITH RECURSIVE role2role(role1_id, role2_id) AS 
				(
					(SELECT 
						a.role1_id, a.role2_id 
					FROM 
						eb_role2role a 
					WHERE 
						a.role1_id = ANY(SELECT _r2user1.role_id FROM eb_role2user _r2user1 WHERE _r2user1.user_id = ANY (SELECT _usertbl.id FROM eb_users _usertbl WHERE _usertbl.email= $1 AND _usertbl.pwd = $2)))
					UNION ALL 
						SELECT b.role1_id, b.role2_id FROM eb_role2role b, role2role c  WHERE b.role1_id = c.role2_id)
					SELECT DISTINCT role2_id FROM role2role
				)
			);
END;
$$ LANGUAGE plpgsql;



-------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION getallpermissions( uname text,pwd text)
RETURNS TABLE (pid integer, oid integer, opid integer ) AS $$
BEGIN
	RETURN QUERY 
SELECT 
	_per.id,
	_per.object_id,
	_per.operation_id 
FROM 
	eb_permissions _per
WHERE id = ANY (
					SELECT DISTINCT _per2role.permission_id FROM eb_permission2role _per2role WHERE _per2role.role_id = ANY 
        ((SELECT _r2user.role_id FROM eb_role2user _r2user WHERE _r2user.user_id = ANY (SELECT _usertbl.id FROM eb_users _usertbl WHERE _usertbl.email= $1 AND _usertbl.pwd = $2))
            UNION
            (WITH RECURSIVE role2role(role1_id, role2_id) AS  
                (SELECT a.role1_id, a.role2_id FROM eb_role2role a  
                WHERE a.role1_id  IN(SELECT _r2user1.role_id FROM eb_role2user _r2user1 WHERE _r2user1.user_id = ANY (SELECT _usertbl1.id FROM eb_users _usertbl1 WHERE _usertbl1.email= $1 AND _usertbl1.pwd = $2))
                UNION ALL 
                    SELECT b.role1_id, b.role2_id FROM eb_role2role b, role2role c 
                    	WHERE b.role1_id = c.role2_id) 
                SELECT DISTINCT role2_id FROM role2role))
			);
END;
$$ LANGUAGE plpgsql;

