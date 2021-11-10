-- Table: public.eb_stage_actions

-- DROP TABLE public.eb_stage_actions;

CREATE TABLE eb_stage_actions
(
    id SERIAL,
    action_unique_id text ,
    action_name text,
    eb_stages_id integer,
    eb_del  "char" DEFAULT 'F'::"char",
    CONSTRAINT "eb_stage_actions _pkey" PRIMARY KEY (id)
);

-- Index: eb_stage_actions_id_idx

-- DROP INDEX public.eb_stage_actions_id_idx;

CREATE INDEX eb_stage_actions_id_idx
    ON eb_stage_actions(id);