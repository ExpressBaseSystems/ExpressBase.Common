CREATE SEQUENCE eb_usergroup_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_usergroup
(
    id int default(NEXT VALUE FOR eb_usergroup_id_seq) primary key,
    name varchar(max) ,
    description varchar(max) ,
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
)

CREATE INDEX eb_usergroup_id_idx ON eb_usergroup(id);
CREATE INDEX eb_usergroup_eb_del_idx ON eb_usergroup(eb_del);