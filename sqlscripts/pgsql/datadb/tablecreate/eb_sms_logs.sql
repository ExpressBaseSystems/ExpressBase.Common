-- Table: public.eb_sms_logs

-- DROP TABLE public.eb_sms_logs;

CREATE TABLE eb_sms_logs
(
    id serial,
    send_to text,
    send_from text,
    message_body text,
    status text,
    result text,
    refid text,
    metadata json,
    retryof integer,
    isfallback "char" DEFAULT 'F'::"char",
    con_id integer,
    req_from text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_sms_logs_pkey PRIMARY KEY (id)
);

-- DROP INDEX public.eb_sms_logs_eb_del_idx;

CREATE INDEX eb_sms_logs_eb_del_idx
    ON public.eb_sms_logs USING btree
    (eb_del ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: eb_sms_logs_id_idx

-- DROP INDEX public.eb_sms_logs_id_idx;

CREATE INDEX eb_sms_logs_id_idx
    ON public.eb_sms_logs USING btree
    (id ASC NULLS LAST)
    TABLESPACE pg_default;