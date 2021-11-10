CREATE SEQUENCE eb_public_holidays_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_public_holidays
(
    id int default(NEXT VALUE FOR eb_public_holidays_id_seq) primary key,
    eb_loc_id int,
    holiday_name varchar(max),
    holiday_date datetime2
);

CREATE INDEX eb_public_holidays_id_idx ON eb_public_holidays(id);

