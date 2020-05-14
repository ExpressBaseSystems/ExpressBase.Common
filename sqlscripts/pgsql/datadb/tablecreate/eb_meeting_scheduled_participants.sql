CREATE TABLE eb_meeting_scheduled_participants(
id serial ,
user_id integer,
role_id integer,
user_group_id integer,
eb_meeting_schedule_id integer,
participant_type integer,
eb_created_by integer,
eb_created_at 	timestamp without time zone DEFAULT now(),
eb_lastmodified_by integer,
eb_lastmodified_at timestamp without time zone,
eb_del char(1) default 'F'
);

