CREATE TABLE eb_google_map
(
  id integer NOT NULL auto_increment,
  lattitude text,
  longitude text,
  name text,
  CONSTRAINT eb_google_map_pkey PRIMARY KEY (Id)
);

CREATE INDEX eb_google_map_id_idx
    ON eb_google_map(id);
