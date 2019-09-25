-- Table: public.eb_languages

-- DROP TABLE public.eb_languages;

CREATE TABLE public.eb_languages
(
    id serial,
    language text NOT NULL,
    CONSTRAINT eb_languages_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_languages_id_idx

-- DROP INDEX public.eb_languages_id_idx;

CREATE INDEX eb_languages_id_idx
    ON public.eb_languages USING btree
    (id)
    TABLESPACE pg_default;
