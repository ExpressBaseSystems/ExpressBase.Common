CREATE TABLE eb_location_types
(
    id SERIAL,
    type text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F'
);

CREATE INDEX eb_location_types_id_idx ON eb_location_types(id);
CREATE INDEX eb_location_types_eb_del_idx ON eb_location_types(eb_del);