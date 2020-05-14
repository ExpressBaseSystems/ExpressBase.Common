
CREATE TABLE eb_meeting_schedule(
id serial,
title text,
description text,
date  meeting_date,
time_from time without time zone,
time_to time without time zone,
duration integer,
break text ,
is_recuring char(1) default 'F',
is_multiple char(1) default 'F',
venue text,
integration	text,
max_hosts integer,
max_attendees integer,
no_of_attendee integer,
no_of_hosts  integer,	
form_ref_id  text,
form_data_id integer,
cron_expression text,
cron_exp_end date,
eb_created_by integer,
eb_created_at 	timestamp without time zone DEFAULT now(),
eb_lastmodified_by integer,
eb_lastmodified_at timestamp without time zone,
eb_del char(1) default 'F'
);

CREATE INDEX eb_meeting_schedule_id_idx
ON eb_meeting_schedule(id);