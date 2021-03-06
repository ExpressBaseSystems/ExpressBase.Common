-- Table: public.eb_constraints_line

-- DROP TABLE public.eb_constraints_line;

CREATE TABLE eb_constraints_line
(
    id serial,
    master_id integer,
    c_type integer,
    c_operation integer,
    c_value text,
    CONSTRAINT eb_constraints_line_pkey PRIMARY KEY (id)
);


	
-- Index: eb_constraints_line_id_idx

-- DROP INDEX public.eb_constraints_line_id_idx;

CREATE INDEX eb_constraints_line_id_idx
    ON eb_constraints_line(id);