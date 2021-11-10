CREATE SEQUENCE eb_objects_relations_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_objects_relations
(
    id int default (NEXT VALUE FOR eb_objects_relations_id_seq),
    dominant varchar(max),
    dependant varchar(max),    
    removed_by integer,
    removed_at datetime,
    eb_del char DEFAULT 'F',
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id),
    CONSTRAINT eb_objects_relations_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_objects_relations_eb_del_idx
    ON eb_objects_relations(eb_del);



CREATE INDEX eb_objects_relations_id_idx
    ON eb_objects_relations(id);