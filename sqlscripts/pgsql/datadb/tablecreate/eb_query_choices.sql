-- Table: public.eb_query_choices

-- DROP TABLE public.eb_query_choices;

CREATE TABLE eb_query_choices
(
    id serial,
    q_id integer,
    choice text,
    eb_del char(1) DEFAULT 'F',
    score integer,
	CONSTRAINT eb_query_choices_pkey PRIMARY KEY (id)
);


-- Index: eb_query_choices_id_idx

-- DROP INDEX public.eb_query_choices_id_idx;

CREATE INDEX eb_query_choices_id_idx
    ON eb_query_choices(id);