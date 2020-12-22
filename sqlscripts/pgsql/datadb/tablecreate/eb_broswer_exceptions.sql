-- Table: public.eb_broswer_exceptions

-- DROP TABLE public.eb_broswer_exceptions;

CREATE TABLE public.eb_broswer_exceptions
(
    id serial,
    user_id integer,
    device_info text,
    ip_address text,
    error_msg text,
    eb_created_at timestamp without time zone,
	CONSTRAINT eb_broswer_exceptions_pkey PRIMARY KEY (id)
);

-- Index: eb_broswer_exceptions_id_idx

-- DROP INDEX public.eb_broswer_exceptions_id_idx;

CREATE INDEX eb_broswer_exceptions_id_idx
ON eb_broswer_exceptions(id);