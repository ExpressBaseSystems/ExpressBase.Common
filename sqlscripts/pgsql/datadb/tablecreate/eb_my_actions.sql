CREATE TABLE eb_my_actions
(
    id SERIAL,
    user_ids text,
    role_ids text,
    usergroup_id integer,
    is_completed char(1),
    completed_at timestamp without time zone,
    completed_by integer,
    eb_stages_id integer,
    form_ref_id text,
    form_data_id integer,
    eb_del char(1) DEFAULT 'F',
    eb_approval_lines_id integer,
    description text,
    is_form_data_editable char(1) DEFAULT 'F',
    from_datetime timestamp without time zone,
    expiry_datetime timestamp without time zone,
    CONSTRAINT eb_my_actions_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_my_actions_id_idx ON eb_my_actions(id);