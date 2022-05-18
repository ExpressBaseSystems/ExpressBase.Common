-- Table: public.eb_downloads

-- DROP TABLE IF EXISTS public.eb_downloads;

CREATE TABLE public.eb_downloads
(
    id serial,
    filename text,
    bytea bytea,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_downloads_pkey PRIMARY KEY (id)
);



-- Index: eb_downloads_id_idx

-- DROP INDEX public.eb_downloads_id_idx;

CREATE INDEX eb_downloads_id_idx
    ON eb_downloads(id);
