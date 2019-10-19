-- Table: public.eb_keys

-- DROP TABLE public.eb_keys;

CREATE TABLE public.eb_keys
(
    id serial,
    key text NOT NULL,
    CONSTRAINT eb_keys_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_keys_id_idx

-- DROP INDEX public.eb_keys_id_idx;

CREATE INDEX eb_keys_id_idx
    ON public.eb_keys USING btree
    (id)
    TABLESPACE pg_default;