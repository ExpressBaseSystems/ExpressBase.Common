-- Table: public.eb_index_table

-- DROP TABLE public.eb_index_table;

CREATE TABLE eb_index_table
(
    id bigserial,
    display_name text,
    data_json text,
    ref_id text,
    data_id integer,	
    link_type integer,
    created_by integer,
    created_at timestamp without time zone,
    modified_by integer,
    modified_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_index_table_pkey PRIMARY KEY (id)
);

-- Index: eb_index_table_id_idx

-- DROP INDEX public.eb_index_table_id_idx;

CREATE INDEX eb_index_table_id_idx
ON eb_index_table(id);

