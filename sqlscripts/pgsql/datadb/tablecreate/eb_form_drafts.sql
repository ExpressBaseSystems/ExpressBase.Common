-- Table: public.eb_form_drafts

-- DROP TABLE public.eb_form_drafts;

CREATE TABLE public.eb_form_drafts
(
    id SERIAL,
    title text,
    form_data_json text,
    form_ref_id text,
    form_data_id integer,
    is_submitted "char" DEFAULT 'F'::"char",
    eb_loc_id integer,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_lastmodified_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_form_drafts_pkey PRIMARY KEY (id)
);

-- Index: public.eb_form_drafts_id_idx

-- DROP INDEX public.eb_form_drafts_id_idx;

CREATE INDEX eb_form_drafts_id_idx
    ON eb_form_drafts(id);