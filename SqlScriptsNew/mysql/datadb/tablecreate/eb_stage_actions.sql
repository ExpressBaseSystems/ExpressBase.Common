CREATE TABLE eb_stage_actions
(
    id integer auto_increment,
    action_unique_id text,
    action_name text,
    eb_stages_id integer,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_stage_actions_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_stage_actions_id_idx
ON eb_stage_actions(id);

CREATE INDEX eb_stage_actions_eb_del_idx
ON eb_stage_actions(eb_del);