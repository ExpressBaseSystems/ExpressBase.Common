-- Table: public.eb_meeting_scheduled_participants

-- DROP TABLE public.eb_meeting_scheduled_participants;

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
type_of_user integer,
user_ids text,
role_ids text,
CONSTRAINT eb_meeting_scheduled_participants_pkey PRIMARY KEY (id)
);

-- Index: eb_meeting_scheduled_participants_id_idx

-- DROP INDEX public.eb_meeting_scheduled_participants_id_idx;

CREATE INDEX eb_meeting_scheduled_participants_id_idx
    ON eb_meeting_scheduled_participants(id);

