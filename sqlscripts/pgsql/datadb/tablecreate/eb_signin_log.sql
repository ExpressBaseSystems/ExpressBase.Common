-- Table: public.eb_signin_log

-- DROP TABLE public.eb_signin_log;

CREATE TABLE eb_signin_log
(
    id serial,
    user_id integer,
    ip_address text,
    device_info text,
    is_attempt_failed char(1) DEFAULT 'F',	
    is_force_signout char(1)  DEFAULT 'F',
    signin_at timestamp without time zone,
    signout_at timestamp without time zone,
    CONSTRAINT eb_signin_log_pkey PRIMARY KEY (id)
);


-- Index: eb_signin_log_id_idx

-- DROP INDEX public.eb_signin_log_id_idx;

CREATE INDEX eb_signin_log_id_idx
    ON eb_signin_log(id);