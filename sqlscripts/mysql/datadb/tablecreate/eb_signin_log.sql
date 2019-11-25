CREATE TABLE eb_signin_log
(
    id integer auto_increment,
    user_id integer,
    ip_address text,
    device_info text,
    is_attempt_failed char(1) DEFAULT 'F',	
    is_force_signout char(1) DEFAULT 'F',
    signin_at datetime,
    signout_at datetime,
    CONSTRAINT eb_signin_log_pkey PRIMARY KEY (id)
);
