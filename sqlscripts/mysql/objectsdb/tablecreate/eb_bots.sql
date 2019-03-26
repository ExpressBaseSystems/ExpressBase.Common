CREATE TABLE eb_bots
(
  id integer NOT NULL auto_increment,
  name text,
  url text,
  welcome_msg text,
  botid varchar(100),
  modified_by integer,
  solution_id integer,
  created_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  modified_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  created_by integer,
  app_id integer,
  fullname text,
  CONSTRAINT eb_bots_pkey PRIMARY KEY (id),
  CONSTRAINT botid_uniquekey UNIQUE (botid)
);


CREATE INDEX eb_bots_app_id_idx
  ON eb_bots
  (app_id)USING btree;

CREATE INDEX eb_bots_id_idx
  ON eb_bots
  (id)USING btree;