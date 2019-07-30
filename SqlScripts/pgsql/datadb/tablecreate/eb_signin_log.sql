-- Table: public.eb_signin_log

-- DROP TABLE public.eb_signin_log;

CREATE TABLE public.eb_signin_log
(
    id serial,
    user_id integer,
    ip_address text COLLATE pg_catalog."default",
    device_info text COLLATE pg_catalog."default",
    is_attempt_failed character(1) COLLATE pg_catalog."default" DEFAULT 'F'::bpchar,	
    is_force_signout character(1) COLLATE pg_catalog."default" DEFAULT 'F'::bpchar,
    signin_at timestamp without time zone,
    signout_at timestamp without time zone,
    CONSTRAINT eb_signin_log_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_signin_log
    OWNER to postgres;


-- Index: eb_signin_log_id_idx

-- DROP INDEX public.eb_signin_log_id_idx;

CREATE INDEX eb_signin_log_id_idx
    ON public.eb_signin_log USING btree
    (id)
    TABLESPACE pg_default;