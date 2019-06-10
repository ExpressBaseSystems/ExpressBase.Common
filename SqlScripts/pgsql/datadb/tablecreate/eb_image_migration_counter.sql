-- Table: public.eb_image_migration_counter

-- DROP TABLE public.eb_image_migration_counter;

CREATE TABLE public.eb_image_migration_counter
(
    id integer NOT NULL,
    ftp_get integer DEFAULT 0,
    customer_id integer NOT NULL,
    cldnry_large integer DEFAULT 0,
    cldnry_small integer DEFAULT 0,
    upld integer DEFAULT 0,
    is_exist integer DEFAULT 0,
    file_upld integer DEFAULT 0,
    img_org integer DEFAULT 0,
    filename text COLLATE "default".pg_catalog DEFAULT 'Dummy'::text,
    fileref_id integer,
    CONSTRAINT eb_image_migration_counter_pkey PRIMARY KEY (id)
);
