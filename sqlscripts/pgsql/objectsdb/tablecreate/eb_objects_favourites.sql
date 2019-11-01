-- Table: public.eb_objects_favourites

-- DROP TABLE public.eb_objects_favourites;

CREATE TABLE eb_objects_favourites
(
    id serial,
    userid integer,
    object_id integer,
    eb_del char(1) DEFAULT 'F'
);
