CREATE TABLE eb_meeting_scheduled_participants
(
	id integer auto_increment ,
	user_id integer,
	role_id integer,
	user_group_id integer,
	eb_meeting_schedule_id integer,
	participant_type integer,
	eb_created_by integer,
	eb_created_at datetime DEFAULT now(),
	eb_lastmodified_by integer,
	eb_lastmodified_at datetime,
	eb_del char(1) DEFAULT 'F',
	CONSTRAINT eb_meeting_scheduled_participants_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meeting_scheduled_participants_id_idx 
	ON eb_meeting_scheduled_participants(id);

CREATE INDEX eb_meeting_scheduled_participants_eb_del_idx 
	ON eb_meeting_scheduled_participants(eb_del);
