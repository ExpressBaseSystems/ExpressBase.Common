CREATE SEQUENCE eb_applications_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_applications
(
    id int default (NEXT VALUE FOR eb_applications_id_seq),
    applicationname varchar(max),
    description varchar(max),
    app_icon varchar(max),
    application_type integer,
    eb_del char  DEFAULT 'F',
    app_settings varchar(max),
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
    CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


CREATE INDEX eb_applications_id_idx
    ON eb_applications(id);

CREATE INDEX eb_applications_eb_del_idx
    ON eb_applications(eb_del);