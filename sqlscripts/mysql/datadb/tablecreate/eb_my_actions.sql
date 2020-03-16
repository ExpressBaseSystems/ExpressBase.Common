CREATE TABLE eb_my_actions
(
    id integer auto_increment,
    user_ids text,
    role_ids text,
    usergroup_id integer,
    is_completed char(1) DEFAULT 'F',
    completed_at datetime,
    completed_by integer,
    eb_stages_id integer,
    form_ref_id text,
    form_data_id integer,
    eb_del char(1) DEFAULT 'F',
    eb_approval_lines_id integer,
    description text,
    is_form_data_editable char(1) DEFAULT 'F',
    from_datetime datetime,
    expiry_datetime datetime,
    CONSTRAINT eb_my_actions_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_my_actions_id_idx
ON eb_my_actions(id);

CREATE INDEX eb_my_actions_eb_del_idx
ON eb_my_actions(eb_del);