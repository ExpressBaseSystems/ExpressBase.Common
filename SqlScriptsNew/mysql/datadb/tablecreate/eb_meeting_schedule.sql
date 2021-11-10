CREATE TABLE eb_meeting_schedule
(
	id integer auto_increment,
	title text,
	description text,
	meeting_date date,
	time_from datetime,
	time_to datetime,
	duration integer,
	break text ,
	is_recuring char(1) DEFAULT 'F',
	is_multiple char(1) DEFAULT 'F',
	venue text,
	integration text,
	max_hosts integer,
	max_attendees integer,
	no_of_attendee integer,
	no_of_hosts	integer,	
	form_ref_id	text,
	form_data_id integer,
	cron_expression text,
	cron_exp_end date,
	eb_created_by integer,
	eb_created_at datetime DEFAULT now(),
	eb_lastmodified_by integer,
	eb_lastmodified_at datetime,
	eb_del char(1) DEFAULT 'F',
	CONSTRAINT eb_meeting_schedule_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meeting_schedule_id_idx 
	ON eb_meeting_schedule(id);

CREATE INDEX eb_meeting_schedule_eb_del_idx 
	ON eb_meeting_schedule(eb_del);
