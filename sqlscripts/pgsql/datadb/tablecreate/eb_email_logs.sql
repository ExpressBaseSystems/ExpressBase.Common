-- Table: public.eb_email_logs

-- DROP TABLE public.eb_email_logs;

CREATE TABLE eb_email_logs
(
	id serial,
    send_to text,
    send_from text,
	recepients json,
    message_body text,
    attachmentname text,
    subject text,
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
    CONSTRAINT eb_email_logs_pkey PRIMARY KEY (id)
);



-- Index: eb_email_logs_id_idx

-- DROP INDEX public.eb_email_logs_id_idx;

CREATE INDEX eb_email_logs_id_idx
    ON eb_email_logs(id);
