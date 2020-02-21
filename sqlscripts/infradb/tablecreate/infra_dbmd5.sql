-- Table: public.infra_dbmd5

-- DROP TABLE public.infra_dbmd5;

CREATE TABLE public.infra_dbmd5
(
    id SERIAL,
    change_id integer,
    filename text COLLATE pg_catalog."default",
    contents text COLLATE pg_catalog."default",
    eb_del "char",
    CONSTRAINT eb_dbmd5_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.infra_dbmd5
    OWNER to postgres;
	
CREATE INDEX infra_dbmd5_id_idx ON infra_dbmd5(id);

CREATE INDEX infra_dbmd5_change_id_idx ON infra_dbmd5(change_id);