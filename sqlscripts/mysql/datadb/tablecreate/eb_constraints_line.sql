CREATE TABLE eb_constraints_line
(
    id integer auto_increment,
    master_id integer,
    c_type integer,
    c_operation integer,
    c_value text,
    CONSTRAINT eb_constraints_line_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_constraints_line_id_idx
ON eb_constraints_line(id);