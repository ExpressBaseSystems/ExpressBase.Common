-- Table: public.eb_files_ref_variations

-- DROP TABLE public.eb_files_ref_variations;

CREATE TABLE eb_files_ref_variations
(
    id serial,
    eb_files_ref_id integer NOT NULL,
    filestore_sid text,
    length bigint,
    is_image char(1),
    imagequality_id integer,
    img_manp_ser_con_id integer,
    filedb_con_id integer,
    CONSTRAINT eb_files_ref_variations_pkey PRIMARY KEY (id)
);

-- Index: eb_files_ref_variations_id_idx

-- DROP INDEX public.eb_files_ref_variations_id_idx;

CREATE INDEX eb_files_ref_variations_id_idx
    ON eb_files_ref_variations(id);

-- Index: eb_files_variations_files_refid_idx

-- DROP INDEX public.eb_files_variations_files_refid_idx;

CREATE INDEX eb_files_variations_files_refid_idx
    ON eb_files_ref_variations(eb_files_ref_id);