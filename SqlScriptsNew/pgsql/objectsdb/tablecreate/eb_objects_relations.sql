-- Table: public.eb_objects_relations

-- DROP TABLE public.eb_objects_relations;

CREATE TABLE eb_objects_relations
(
	id serial,
    dominant text,
    dependant text,
    removed_by integer,
    removed_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_relations_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_objects_relations_eb_del_idx

-- DROP INDEX public.eb_objects_relations_eb_del_idx;

CREATE INDEX eb_objects_relations_eb_del_idx
    ON eb_objects_relations(eb_del);

-- Index: eb_objects_relations_id_idx

-- DROP INDEX public.eb_objects_relations_id_idx;

CREATE INDEX eb_objects_relations_id_idx
    ON eb_objects_relations(id);