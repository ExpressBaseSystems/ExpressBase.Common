-- Table: public.eb_objects_favourites

-- DROP TABLE public.eb_objects_favourites;

CREATE TABLE eb_objects_favourites
(
    id serial,
    userid integer,
    object_id integer,
    eb_del "char" DEFAULT 'F'::"char",
	CONSTRAINT eb_objects_favourites_pkey PRIMARY KEY (id)
);

-- Index: eb_objects_favourites_id_idx

-- DROP INDEX public.eb_objects_favourites_id_idx;

CREATE INDEX eb_objects_favourites_id_idx
    ON eb_objects_favourites(id);
