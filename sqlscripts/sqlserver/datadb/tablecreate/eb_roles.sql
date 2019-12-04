CREATE SEQUENCE eb_roles_id_seq START WITH 101 INCREMENT BY 1;

CREATE TABLE eb_roles
(
	id int default (NEXT VALUE FOR eb_roles_id_seq),
    role_name varchar(100),
    applicationname varchar(max) ,
    applicationid int,
    description varchar(max) ,
    eb_del "char" NOT NULL DEFAULT 'F',
    is_anonymous "char" NOT NULL DEFAULT 'F',
    CONSTRAINT eb_rolename_unique UNIQUE (role_name),
    CONSTRAINT eb_roles_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE UNIQUE INDEX eb_roles_id_idx ON eb_roles(id);
CREATE INDEX eb_roles_eb_del_idx ON eb_roles (eb_del);

