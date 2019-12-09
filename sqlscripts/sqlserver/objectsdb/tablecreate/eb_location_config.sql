CREATE SEQUENCE eb_location_config_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_location_config
(
    id int default (NEXT VALUE FOR eb_location_config_id_seq),
    keys varchar(max),
    isrequired char DEFAULT 'F',
    keytype varchar(max),
    eb_del char DEFAULT 'F',
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_locationsconfig_id_idx
    ON eb_location_config(id);

