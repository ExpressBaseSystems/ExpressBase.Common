-- Table: public.eb_my_actions

-- DROP TABLE public.eb_my_actions;
-- Table: public.eb_my_actions

-- DROP TABLE public.eb_my_actions;

CREATE TABLE eb_my_actions
(
    id SERIAL,
    user_ids text,
    role_ids text,
    usergroup_id integer,
    is_completed  "char" DEFAULT 'F'::"char",
    completed_at timestamp without time zone,
    completed_by integer,
    eb_stages_id integer,
    form_ref_id text,
    form_data_id integer,
    eb_del  "char" DEFAULT 'F'::"char",
    eb_approval_lines_id integer,
    description text,
    is_form_data_editable  "char" DEFAULT 'F'::"char",
    from_datetime timestamp without time zone,
    expiry_datetime timestamp without time zone,
	my_action_type text,
	exec_cxt_id integer,
	eb_meeting_slots_id integer,
    CONSTRAINT eb_my_actions_pkey PRIMARY KEY (id)
);

-- Index: eb_my_actions_id_idx

-- DROP INDEX public.eb_my_actions_id_idx;

CREATE INDEX eb_my_actions_id_idx ON eb_my_actions(id);