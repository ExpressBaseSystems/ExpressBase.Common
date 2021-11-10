-- Table: public.eb_keyvalue

-- DROP TABLE public.eb_keyvalue;

CREATE TABLE eb_keyvalue
(
    id bigserial,
    key_id bigint NOT NULL,
    lang_id integer NOT NULL,
    value text NOT NULL,
    CONSTRAINT eb_keyvalue_pkey PRIMARY KEY (id)
);


-- Index: eb_keyvalue_id_idx

-- DROP INDEX public.eb_keyvalue_id_idx;

CREATE INDEX eb_keyvalue_id_idx
    ON eb_keyvalue(id);
