CREATE SEQUENCE eb_objects_favourites_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects_favourites
(
    id int default (NEXT VALUE FOR eb_objects_favourites_id_seq),
    userid integer,
    object_id integer,
    eb_del char DEFAULT 'F'

);

CREATE INDEX eb_objects_favourites_id_idx
    ON eb_objects_favourites(id);

