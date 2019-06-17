-- Table: public.eb_objects_favourites

-- DROP TABLE public.eb_objects_favourites;

CREATE TABLE public.eb_objects_favourites
(
    id serial,
    userid integer,
    object_id integer,
    eb_del "char" DEFAULT 'F'::"char"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_favourites
    OWNER to postgres;