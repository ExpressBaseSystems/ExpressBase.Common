CREATE SEQUENCE eb_constraints_master_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_constraints_master
(
    id int default(NEXT VALUE FOR eb_constraints_master_id_seq) primary key,
    key_id int,
    key_type int,
    description varchar(max),
    eb_created_by int,
    eb_created_at datetime2(6),
    eb_lastmodified_by int,
    eb_lastmodified_at datetime2(6),
    eb_del character(1)  DEFAULT 'F'
);

CREATE INDEX eb_constraints_master_id_idx ON eb_constraints_master(id);