CREATE TABLE eb_languages
(
  id integer NOT NULL auto_increment,
  language varchar(25) NOT NULL,
  CONSTRAINT eb_languages_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_languages_idx
ON eb_languages(id) 
USING btree;



CREATE INDEX eb_languages_lang_idx
ON eb_languages(language) 
USING btree;
