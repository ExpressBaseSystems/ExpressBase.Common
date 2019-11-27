CREATE TABLE eb_languages
(
  id integer NOT NULL auto_increment,
  language text NOT NULL,
  CONSTRAINT eb_languages_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_languages_id_idx
ON eb_languages(id);

