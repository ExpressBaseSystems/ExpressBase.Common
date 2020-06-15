-- Table: public.eb_approval_lines

-- DROP TABLE public.eb_approval_lines;

CREATE TABLE eb_approval_lines
(
    id SERIAL,
    stage_unique_id text,
    action_unique_id text ,
    eb_my_actions_id numeric,
    comments text,
    eb_src_id integer,
    eb_ver_id integer,
    eb_loc_id integer,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
    CONSTRAINT eb_approval_lines_pkey PRIMARY KEY (id)
);
-- Index: eb_approval_lines_id_idx

-- DROP INDEX public.eb_approval_lines_id_idx;

CREATE INDEX eb_approval_lines_id_idx ON public.eb_approval_lines(id);

