-- Table: public.eb_fin_years_lines

-- DROP TABLE public.eb_fin_years_lines;

CREATE TABLE public.eb_fin_years_lines
(
	id serial,
	active_start date,
	active_end date,
	locked_ids text,
	partially_locked_ids text,
	eb_fin_years_id integer,
	eb_created_by integer,
	eb_created_at timestamp without time zone,
	eb_lastmodified_by integer,
	eb_lastmodified_at timestamp without time zone,
	eb_del "char" DEFAULT 'F'::"char",
	CONSTRAINT eb_fin_years_lines_pkey PRIMARY KEY (id)
)

-- Index: eb_fin_years_lines_id_idx

-- DROP INDEX public.eb_fin_years_lines_id_idx;

CREATE INDEX eb_fin_years_lines_id_idx
ON eb_fin_years_lines(id);