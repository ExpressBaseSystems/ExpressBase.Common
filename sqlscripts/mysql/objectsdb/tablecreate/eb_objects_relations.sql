-- Table: eb_objects_relations

-- DROP TABLE eb_objects_relations;

CREATE TABLE eb_objects_relations
(
    dominant text ,
    dependant text ,
    id integer NOT NULL AUTO_INCREMENT,
    eb_del1 boolean,
    removed_by integer,
    removed_at timestamp,
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_relations_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_objects_relations_eb_del_idx

-- ALTER TABLE eb_objects_relations DROP INDEX eb_objects_relations_eb_del_idx;

CREATE INDEX eb_objects_relations_eb_del_idx
    ON eb_objects_relations(eb_del);

-- Index: eb_objects_relations_id_idx

-- ALTER TABLE eb_objects_relations DROP INDEX eb_objects_relations_id_idx;

CREATE INDEX eb_objects_relations_id_idx
    ON eb_objects_relations(id);