CREATE TABLE eb_stage_actions
(
    id SERIAL,
    action_unique_id text ,
    action_name text,
    eb_stages_id integer,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT "eb_stage_actions _pkey" PRIMARY KEY (id)
);