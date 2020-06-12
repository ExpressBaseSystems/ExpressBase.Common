-- Table: public.eb_meeting_schedule

-- DROP TABLE public.eb_meeting_schedule;

CREATE TABLE eb_meeting_schedule(
id serial,
title text,
description text,
meeting_date date  ,
time_from time without time zone,
time_to time without time zone,
duration integer,
break text ,
is_recuring "char" DEFAULT 'F'::"char",
is_multiple "char" DEFAULT 'F'::"char",
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
eb_del "char" DEFAULT 'F'::"char",
CONSTRAINT eb_meeting_schedule_pkey PRIMARY KEY (id)
);

-- Index: eb_meeting_schedule_id_idx

-- DROP INDEX public.eb_meeting_schedule_id_idx;

CREATE INDEX eb_meeting_schedule_id_idx
ON eb_meeting_schedule(id);