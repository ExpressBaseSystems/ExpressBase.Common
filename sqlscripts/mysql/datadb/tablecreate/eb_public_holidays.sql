CREATE TABLE eb_public_holidays
(
    id integer auto_increment,
    eb_loc_id integer,
    holiday_name text,
    holiday_date datetime,
    CONSTRAINT eb_public_holidays_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_public_holidays_id_idx
ON eb_public_holidays(id);