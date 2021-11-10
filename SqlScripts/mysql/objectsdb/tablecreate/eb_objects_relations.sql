CREATE TABLE eb_objects_relations
(
	id integer auto_increment,
	dominant text,
	dependant text,
	removed_by integer,
	removed_at datetime,
	eb_del char(1) DEFAULT 'F',
	CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id),
	CONSTRAINT eb_objects_relations_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_objects_relations_eb_del_idx
    ON eb_objects_relations(eb_del);

CREATE INDEX eb_objects_relations_id_idx
    ON eb_objects_relations(id);
