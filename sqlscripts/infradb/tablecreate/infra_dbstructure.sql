-- Table: public.infra_dbstructure

-- DROP TABLE public.infra_dbstructure;

CREATE TABLE public.infra_dbstructure
(
    id SERIAL,
    filename text COLLATE pg_catalog."default",
    filepath text COLLATE pg_catalog."default",
    vendor text COLLATE pg_catalog."default",
    type text COLLATE pg_catalog."default",
    eb_del "char",
    CONSTRAINT eb_dbchanges_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.infra_dbstructure
    OWNER to postgres;
	
CREATE INDEX infra_dbstructure_id_idx ON infra_dbstructure(id);

