-- Table: public.eb_surveys

-- DROP TABLE public.eb_surveys;

CREATE TABLE eb_surveys
(
    id serial,
    name text,
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    status integer,
    questions text,
    CONSTRAINT eb_surveys_pkey PRIMARY KEY (id)
);


-- Index: eb_surveys_id_idx

-- DROP INDEX public.eb_surveys_id_idx;

CREATE INDEX eb_surveys_id_idx
    ON eb_surveys(id);