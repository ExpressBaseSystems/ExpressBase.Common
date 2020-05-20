CREATE TABLE eb_meeting_slots
(
	id integer auto_increment,
	eb_meeting_schedule_id integer,
	is_approved char(1) DEFAULT 'F',
	meeting_date date ,
	time_from datetime,
	time_to	datetime,
	eb_created_by integer,
	eb_created_at datetime DEFAULT now(),
	eb_lastmodified_by integer,
	eb_lastmodified_at datetime,
	eb_del char(1) DEFAULT 'F',
	CONSTRAINT eb_meeting_slots_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meeting_slots_id_idx 
	ON eb_meeting_slots(id);

CREATE INDEX eb_meeting_slots_eb_del_idx 
	ON eb_meeting_slots(eb_del);
