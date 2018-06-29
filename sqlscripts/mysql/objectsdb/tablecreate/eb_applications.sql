-- DROP TABLE eb_applications;

CREATE TABLE eb_applications
(
    id integer NOT NULL AUTO_INCREMENT,
    applicationname VARCHAR(30),
    description text,
    app_icon text,
    application_type integer,
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
    CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- ALTER TABLE eb_applications drop index eb_applications_id_idx;

CREATE INDEX eb_applications_id_idx
    ON eb_applications(id);

-- ALTER TABLE eb_applications drop index eb_applications_eb_del_idx;

CREATE INDEX eb_applications_eb_del_idx
    ON eb_applications(eb_del);