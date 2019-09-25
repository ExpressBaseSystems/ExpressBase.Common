-- Table: public.eb_query_choices

-- DROP TABLE public.eb_query_choices;

CREATE TABLE public.eb_query_choices
(
    id serial,
    q_id integer,
    choice text,
    eb_del "char" DEFAULT 'F'::"char",
    score integer,
	CONSTRAINT eb_query_choices_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_query_choices_id_idx

-- DROP INDEX public.eb_query_choices_id_idx;

CREATE INDEX eb_query_choices_id_idx
    ON public.eb_query_choices USING btree
    (id)
    TABLESPACE pg_default;