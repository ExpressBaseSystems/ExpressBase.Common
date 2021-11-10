CREATE TABLE eb_location_types
(
    id integer auto_increment,
    type text,
    eb_created_by integer,
    eb_created_at datetime,
    eb_lastmodified_by integer,
    eb_lastmodified_at datetime,
    eb_del char(1) DEFAULT 'F',
    constraint eb_location_types_pkey primary key(id)
);

CREATE INDEX eb_location_types_eb_del_idx
    ON eb_location_types(eb_del);

CREATE INDEX eb_location_types_id_idx
    ON eb_location_types(id);
