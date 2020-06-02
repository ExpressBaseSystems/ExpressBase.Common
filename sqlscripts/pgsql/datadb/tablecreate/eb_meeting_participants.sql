CREATE TABLE eb_meeting_participants (
id serial,
eb_meeting_id integer,
eb_slot_participant_id bigint,
eb_created_by integer,
eb_created_at 	timestamp without time zone DEFAULT now(),
eb_lastmodified_by integer,
eb_lastmodified_at timestamp without time zone,
eb_del "char" DEFAULT 'F'::"char",
CONSTRAINT eb_meeting_participants_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_meeting_participants_id_idx
ON eb_meeting_participants(id);