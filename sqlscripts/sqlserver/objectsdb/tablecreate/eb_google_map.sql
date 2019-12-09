CREATE SEQUENCE eb_google_map_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_google_map
(
    id int default (NEXT VALUE FOR eb_google_map_id_seq),
    lattitude varchar(max),
    longitude varchar(max),
    name varchar(max),
    CONSTRAINT eb_google_map_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_google_map_id_idx
    ON eb_google_map(id);