CREATE TABLE eb_constraints_master
(
    id integer auto_increment,
    key_id integer,
    key_type integer,
    description text,
    eb_created_by integer,
    eb_created_at datetime,
    eb_lastmodified_by integer,
    eb_lastmodified_at datetime,
    eb_del character(1)  DEFAULT 'F',
    CONSTRAINT eb_constraints_master_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_constraints_master_id_idx
ON eb_constraints_master(id);