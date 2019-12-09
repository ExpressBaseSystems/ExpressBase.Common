CREATE TABLE eb_location_config
(
  id integer auto_increment,
  `keys` text,
  isrequired char(1) DEFAULT 'F',
  keytype text,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_location_config_pkey PRIMARY KEY (id)
);



CREATE INDEX eb_locationsconfig_id_idx
    ON eb_location_config(id);

