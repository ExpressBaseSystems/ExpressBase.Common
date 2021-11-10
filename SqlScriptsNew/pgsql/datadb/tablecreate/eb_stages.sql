-- Table: public.eb_stages

-- DROP TABLE public.eb_stages;

CREATE TABLE eb_stages
(
    id SERIAL,
    stage_name text,
    stage_unique_id text,
    form_ref_id text,
    eb_del  "char" DEFAULT 'F'::"char",
    CONSTRAINT "eb_stages _pkey" PRIMARY KEY (id)
);

-- Index: eb_stages_id_idx

-- DROP INDEX public.eb_stages_id_idx;

CREATE INDEX eb_stages_id_idx
    ON eb_stages(id);