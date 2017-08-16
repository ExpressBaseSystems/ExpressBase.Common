CREATE SEQUENCE IF NOT EXISTS eb_role2user_id_seq START 1;
-- Table: public.eb_role2user

-- DROP TABLE public.eb_role2user;

CREATE TABLE public.eb_role2user
(
    id integer NOT NULL DEFAULT nextval('eb_role2user_id_seq'::regclass),
    role_id integer,
    user_id integer,
    eb_del boolean,
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id)
   
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2user
    OWNER to postgres;

-- Index: eb_role2user_id_idx

-- DROP INDEX public.eb_role2user_id_idx;

CREATE UNIQUE INDEX eb_role2user_id_idx
    ON public.eb_role2user USING btree
    (id)
    TABLESPACE pg_default;