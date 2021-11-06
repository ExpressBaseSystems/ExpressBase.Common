-- Table: public.eb_mail_logs

-- DROP TABLE public.eb_mail_logs;

CREATE TABLE eb_mail_logs
(
	id serial,
    send_to text,
    message_body text,
    status text,
    refid text,
    con_id integer,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
	eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_mail_logs_pkey PRIMARY KEY (id)
);


-- Index: eb_mail_logs_id_idx

-- DROP INDEX public.eb_mail_logs_id_idx;

CREATE INDEX eb_mail_logs_id_idx
    ON eb_mail_logs(id);
