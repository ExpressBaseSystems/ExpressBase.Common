CREATE TABLE eb_notifications
(
    id integer auto_increment,
    user_id integer,
    message_seen char(1) DEFAULT 'F',
    notification_id text,
    notification json,
    created_at datetime DEFAULT now(),
    CONSTRAINT eb_notifications_pkey PRIMARY KEY (id)
);