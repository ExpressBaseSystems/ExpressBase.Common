CREATE TABLE eb_meeting_participants 
(
	id integer auto_increment,
	eb_meeting_id integer,
	eb_slot_participant_id bigint,
	eb_created_by integer,
	eb_created_at datetime DEFAULT now(),
	eb_lastmodified_by integer,
	eb_lastmodified_at datetime,
	eb_del char(1) DEFAULT 'F',
    	CONSTRAINT eb_meeting_participants_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meeting_participants_id_idx 
	ON eb_meeting_participants(id);

CREATE INDEX eb_meeting_participants_eb_del_idx 
	ON eb_meeting_participants(eb_del);
