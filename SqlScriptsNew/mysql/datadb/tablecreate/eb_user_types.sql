CREATE TABLE eb_user_types
(
    id integer auto_increment,
    name text,
    eb_created_by integer,
    eb_created_at datetime,
    eb_lastmodified_by integer,
    eb_lastmodified_at datetime,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_user_types_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_user_types_id_idx
ON eb_user_types(id);

CREATE INDEX eb_user_types_eb_del_idx
ON eb_user_types(eb_del);