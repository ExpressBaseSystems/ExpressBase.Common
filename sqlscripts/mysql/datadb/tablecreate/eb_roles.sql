-- DROP TABLE eb_roles;

CREATE TABLE eb_roles
(
    id INT NOT NULL AUTO_INCREMENT,
    role_name varchar(255)  NOT NULL,
    applicationname varchar(255),
    applicationid INT,
    description varchar(255),
    eb_del char(1) NOT NULL DEFAULT 'F',
    is_anonymous char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    UNIQUE (role_name),
    CHECK(eb_del = 'T' OR eb_del = 'F')
)AUTO_INCREMENT=100;

-- Index: eb_roles_eb_del_idx

-- DROP INDEX public.eb_roles_eb_del_idx;

CREATE INDEX eb_roles_eb_del_idx
    ON eb_roles (eb_del);

-- Index: eb_roles_id_idx

-- DROP INDEX public.eb_roles_id_idx;

CREATE UNIQUE INDEX eb_roles_id_idx
    ON eb_roles (id);
