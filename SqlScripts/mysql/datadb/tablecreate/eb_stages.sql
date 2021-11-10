CREATE TABLE eb_stages
(
    id integer auto_increment,
    stage_name text,
    stage_unique_id text,
    form_ref_id text,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_stages_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_stages_id_idx
ON eb_stages(id);

CREATE INDEX eb_stages_eb_del_idx
ON eb_stages(eb_del);