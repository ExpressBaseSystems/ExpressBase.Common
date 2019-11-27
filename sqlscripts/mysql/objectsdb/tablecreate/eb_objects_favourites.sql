CREATE TABLE eb_objects_favourites
(
    id integer auto_increment,
    userid integer,
    object_id integer,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_objects_favourites_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_objects_favourites_id_idx
    ON eb_objects_favourites(id);
