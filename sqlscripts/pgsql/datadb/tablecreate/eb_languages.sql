-- Table: public.eb_languages

-- DROP TABLE public.eb_languages;

CREATE TABLE eb_languages
(
    id serial,
    code text NOT NULL,
    name text NOT NULL,
    display_name text NOT NULL,
    eb_row_num integer,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_languages_pkey PRIMARY KEY (id)
);


-- Index: eb_languages_id_idx

-- DROP INDEX public.eb_languages_id_idx;

CREATE INDEX eb_languages_id_idx
    ON eb_languages(id);
