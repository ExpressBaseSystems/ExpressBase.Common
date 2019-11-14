
CREATE TABLE eb_public_holidays
(
    id integer auto_increment,
    eb_loc_id integer,
    holiday_name text,
    holiday_date timestamp,
    CONSTRAINT eb_public_holidays_pkey PRIMARY KEY (id)
);