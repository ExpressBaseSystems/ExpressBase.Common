-- Table: public.eb_keys

-- DROP TABLE public.eb_keys;

CREATE TABLE eb_keys
(
    id serial,
    key text NOT NULL,
    CONSTRAINT eb_keys_pkey PRIMARY KEY (id)
);


-- Index: eb_keys_id_idx

-- DROP INDEX public.eb_keys_id_idx;

CREATE INDEX eb_keys_id_idx
    ON eb_keys(id);