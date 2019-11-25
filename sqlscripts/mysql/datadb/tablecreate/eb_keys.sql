CREATE TABLE eb_keys
(
  id integer NOT NULL auto_increment,
  `key` text NOT NULL,
  CONSTRAINT eb_keys_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_keys_id_idx
ON eb_keys(id);
