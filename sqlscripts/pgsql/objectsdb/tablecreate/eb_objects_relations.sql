-- Table: public.eb_objects_relations

-- DROP TABLE public.eb_objects_relations;

CREATE TABLE public.eb_objects_relations
(
	id serial primary key,
    dominant text COLLATE pg_catalog."default",
    dependant text COLLATE pg_catalog."default",
    eb_del1 boolean,
    removed_by integer,
    removed_at timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_relations_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_relations
    OWNER to postgres;

-- Index: eb_objects_relations_eb_del_idx

-- DROP INDEX public.eb_objects_relations_eb_del_idx;

CREATE INDEX eb_objects_relations_eb_del_idx
    ON public.eb_objects_relations USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_objects_relations_id_idx

-- DROP INDEX public.eb_objects_relations_id_idx;

CREATE INDEX eb_objects_relations_id_idx
    ON public.eb_objects_relations USING btree
    (id)
    TABLESPACE pg_default;