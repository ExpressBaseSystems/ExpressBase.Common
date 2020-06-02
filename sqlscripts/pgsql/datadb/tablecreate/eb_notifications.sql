-- Table: public.eb_notifications

-- DROP TABLE public.eb_notifications;

CREATE TABLE eb_notifications
(
    id SERIAL,
    user_id integer,
	message_seen "char" DEFAULT 'F'::"char",
    notification_id text ,
    notification json,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT eb_notifications_pkey PRIMARY KEY (id)
);

-- Index: eb_notificationss_id_idx

-- DROP INDEX public.eb_notificationss_id_idx;

CREATE INDEX eb_notificationss_id_idx
    ON eb_notifications(id);

