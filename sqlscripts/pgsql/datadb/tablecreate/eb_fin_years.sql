-- Table: public.eb_fin_years

-- DROP TABLE public.eb_fin_years;

CREATE TABLE eb_fin_years
(
    id serial,
    fy_start date,
    fy_end date,
    active_start date,
    active_end date,
    eb_loc_ids text,
    eb_lock "char",
    locked_by integer,
    locked_at timestamp without time zone,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_modified_by integer,
    eb_modified_at timestamp without time zone,
    eb_del "char" DEFAULT 'F'::"char",
	CONSTRAINT eb_fin_years_pkey PRIMARY KEY (id)
);

-- Index: eb_fin_years_id_idx

-- DROP INDEX public.eb_fin_years_id_idx;

CREATE INDEX eb_fin_years_id_idx
ON eb_fin_years(id);
