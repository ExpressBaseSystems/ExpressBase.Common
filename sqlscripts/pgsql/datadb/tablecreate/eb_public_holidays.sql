-- Table: public.eb_public_holidays

-- DROP TABLE public.eb_public_holidays;

CREATE TABLE eb_public_holidays
(
    id serial,
    eb_loc_id integer,
    holiday_name text,
    holiday_date timestamp without time zone,
    CONSTRAINT eb_public_holidays_pkey PRIMARY KEY (id)
);

-- Index: eb_public_holidays_idx

-- DROP INDEX public.eb_public_holidays_idx;

CREATE INDEX eb_public_holidays_id_idx
    ON eb_public_holidays(id);

