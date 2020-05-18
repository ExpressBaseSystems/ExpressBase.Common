CREATE TABLE eb_meetings
(
	id integer auto_increment,
	eb_meeting_slots_id integer,
	eb_created_by integer,
	eb_created_at datetime DEFAULT now(),
	eb_lastmodified_by integer,
	eb_lastmodified_at datetime,
	eb_del char(1) DEFAULT 'F',
	CONSTRAINT eb_meetings_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meetings_id_idx 
	ON eb_meetings(id);

CREATE INDEX eb_meetings_eb_del_idx 
	ON eb_meetings(eb_del);
