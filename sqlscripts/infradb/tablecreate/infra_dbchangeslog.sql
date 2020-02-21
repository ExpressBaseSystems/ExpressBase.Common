-- Table: public.infra_dbchangeslog

-- DROP TABLE public.infra_dbchangeslog;

CREATE TABLE public.infra_dbchangeslog
(
    id SERIAL,
    solution_id text COLLATE pg_catalog."default",
    vendor text COLLATE pg_catalog."default",
    modified_at timestamp without time zone
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.infra_dbchangeslog
    OWNER to postgres;
	
CREATE INDEX infra_dbchangeslog_id_idx ON infra_dbchangeslog(id);

CREATE INDEX infra_dbchangeslog_solution_id_idx ON infra_dbchangeslog(solution_id);