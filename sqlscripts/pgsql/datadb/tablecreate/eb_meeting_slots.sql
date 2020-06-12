CREATE TABLE eb_meeting_slots (
id serial,
eb_meeting_schedule_id integer,
is_approved "char" DEFAULT 'F'::"char",
meeting_date date ,
time_from time without time zone,
time_to	time without time zone,
eb_created_by integer,
eb_created_at  timestamp without time zone DEFAULT now(),
eb_lastmodified_by integer,
eb_lastmodified_at timestamp without time zone,
eb_del "char" DEFAULT 'F'::"char",
CONSTRAINT eb_meeting_slots_pkey PRIMARY KEY (id)
);


CREATE INDEX eb_meeting_slots_id_idx
ON eb_meeting_slots(id);
