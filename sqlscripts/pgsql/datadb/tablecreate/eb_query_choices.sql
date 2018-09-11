-- Table: public.eb_query_choices

-- DROP TABLE public.eb_query_choices;

CREATE TABLE public.eb_query_choices
(
    id serial,
    q_id integer,
    choice text COLLATE pg_catalog."default",
    eb_del "char" DEFAULT 'F'::"char",
    score integer
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_query_choices
    OWNER to postgres;

-- Index: eb_query_choices_id_idx

-- DROP INDEX public.eb_query_choices_id_idx;

CREATE INDEX eb_query_choices_id_idx
    ON public.eb_query_choices USING btree
    (id)
    TABLESPACE pg_default;