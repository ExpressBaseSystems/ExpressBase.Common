CREATE TABLE eb_approval
(
    id integer auto_increment,
    review_status text,
    eb_my_actions_id integer,
    eb_approval_lines_id integer,
    eb_src_id integer,
    eb_ver_id integer,
    eb_created_by integer,
    eb_created_at datetime,
    eb_lastmodified_by integer,
    eb_lastmodified_at datetime,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_approval_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_approval_id_idx
ON eb_approval(id);

CREATE INDEX eb_approval_eb_del_idx
ON eb_approval(eb_del);
