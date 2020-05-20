CREATE TABLE eb_meetings(
id 	serial,
eb_meeting_slots_id integer,
eb_created_by integer,
eb_created_at timestamp without time zone DEFAULT now(),
eb_lastmodified_by integer,
eb_lastmodified_at timestamp without time zone,
eb_del char(1) default 'F'
);


CREATE INDEX eb_meetings_id_idx
ON eb_meetings(id);