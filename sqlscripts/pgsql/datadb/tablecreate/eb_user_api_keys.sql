-- Table: public.eb_user_api_keys

-- DROP TABLE public.eb_user_api_keys;

CREATE TABLE eb_user_api_keys
(
    id serial,
	eb_users_id integer,
    api_key text,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_by integer,
    eb_lastmodified_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
	CONSTRAINT eb_user_api_keys_pkey PRIMARY KEY (id)
);

-- Index: eb_user_api_keys_id_idx

-- DROP INDEX public.eb_user_api_keys_id_idx;

CREATE INDEX eb_user_api_keys_id_idx
ON eb_user_api_keys(id);