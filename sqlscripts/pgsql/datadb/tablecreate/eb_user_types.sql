CREATE TABLE eb_user_types
(
    id SERIAL,
    name text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_user_types_pkey PRIMARY KEY (id)
);