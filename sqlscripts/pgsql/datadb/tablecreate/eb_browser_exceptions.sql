-- Table: public.eb_browser_exceptions

-- DROP TABLE public.eb_browser_exceptions;

CREATE TABLE public.eb_browser_exceptions
(
    id serial,
    user_id integer,
    device_info text,
    ip_address text,
    error_msg text,
    eb_created_at timestamp without time zone,
	CONSTRAINT eb_browser_exceptions_pkey PRIMARY KEY (id)
);

-- Index: eb_browser_exceptions_id_idx

-- DROP INDEX public.eb_browser_exceptions_id_idx;

CREATE INDEX eb_browser_exceptions_id_idx
ON eb_browser_exceptions(id);