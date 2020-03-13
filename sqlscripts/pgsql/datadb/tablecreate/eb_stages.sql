CREATE TABLE eb_stages
(
    id SERIAL,
    stage_name text,
    stage_unique_id text,
    form_ref_id text,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT "eb_stages _pkey" PRIMARY KEY (id)
);
