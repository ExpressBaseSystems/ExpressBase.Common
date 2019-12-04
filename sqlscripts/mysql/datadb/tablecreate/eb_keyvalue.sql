CREATE TABLE eb_keyvalue
(
  id integer NOT NULL auto_increment,
  key_id bigint NOT NULL,
  lang_id integer NOT NULL,
  value text NOT NULL,
  CONSTRAINT eb_keyvalue_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_keyvalue_id_idx
ON eb_keyvalue(id);

