CREATE TABLE eb_image_migration_counter
(
    id integer auto_increment,
    ftp_get integer DEFAULT 0,
    customer_id integer NOT NULL,
    cldnry_large integer DEFAULT 0,
    cldnry_small integer DEFAULT 0,
    upld integer DEFAULT 0,
    is_exist integer DEFAULT 0,
    file_upld integer DEFAULT 0,
    img_org integer DEFAULT 0,
    filename varchar(50) DEFAULT "Dummy",
    fileref_id integer,
    CONSTRAINT eb_image_migration_counter_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_image_migration_counter_idx
ON eb_image_migration_counter(id) 
USING btree;

