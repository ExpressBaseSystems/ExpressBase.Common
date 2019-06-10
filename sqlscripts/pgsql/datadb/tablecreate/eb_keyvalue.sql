-- Table: public.eb_keyvalue

-- DROP TABLE public.eb_keyvalue;

CREATE TABLE public.eb_keyvalue
(
    id serial,
    key_id bigint NOT NULL,
    lang_id integer NOT NULL,
    value text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT eb_keyvalue_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_keyvalue
    OWNER to postgres;


-- Index: eb_keyvalue_id_idx

-- DROP INDEX public.eb_keyvalue_id_idx;

CREATE INDEX eb_keyvalue_id_idx
    ON public.eb_keyvalue USING btree
    (id)
    TABLESPACE pg_default;