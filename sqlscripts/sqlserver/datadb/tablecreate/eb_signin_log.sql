CREATE SEQUENCE eb_signin_log_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_signin_log
(
    id int default(NEXT VALUE FOR eb_signin_log_id_seq) primary key,
    user_id int,
    ip_address varchar(max) ,
    device_info varchar(max) ,
    is_attempt_failed character(1) DEFAULT 'F',
    is_force_signout character(1)  DEFAULT 'F',
    signin_at datetime2(6),
    signout_at datetime2(6)
);

CREATE INDEX eb_signin_log_id_idx ON eb_signin_log(id);