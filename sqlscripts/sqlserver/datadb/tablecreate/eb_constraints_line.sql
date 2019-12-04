CREATE SEQUENCE eb_constraints_line_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_constraints_line
(
    id int default(NEXT VALUE FOR eb_constraints_line_id_seq) primary key,
    master_id int,
    c_type int,
    c_operation int,
    c_value varchar(max)
);

CREATE INDEX eb_constraints_line_id_idx ON eb_constraints_line(id);