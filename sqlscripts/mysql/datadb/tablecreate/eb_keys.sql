CREATE TABLE eb_keys
(
  id bigint NOT NULL auto_increment,
  key1 varchar(75) NOT NULL,
  CONSTRAINT eb_keys_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_keys_idx
ON eb_keys(id) 
USING btree;



CREATE INDEX eb_keys_key1_idx
ON eb_keys(key1) 
USING btree;
