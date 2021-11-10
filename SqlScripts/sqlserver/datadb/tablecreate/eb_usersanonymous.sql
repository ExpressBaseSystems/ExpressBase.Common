CREATE SEQUENCE eb_useranonymous_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_usersanonymous
(
    id int default(NEXT VALUE FOR eb_useranonymous_id_seq) primary key,
    fullname varchar(max) ,
    socialid varchar(500) ,
    email varchar(100) ,
    sex varchar(max) ,
    phoneno varchar(max) ,
    firstvisit datetime2(6),
    lastvisit datetime2(6),
    appid int,
    totalvisits int DEFAULT 1,
    ebuserid int DEFAULT 1,
    modifiedby int,
    modifiedat datetime2(6),
    remarks varchar(max) ,
    ipaddress varchar(max) ,
    browser varchar(max) ,
    city varchar(max) ,
    region varchar(max) ,
    country varchar(max) ,
    latitude varchar(max) ,
    longitude varchar(max) ,
    timezone varchar(max) ,
    iplocationjson varchar(max)
);

CREATE INDEX eb_usersanonymous_id_idx ON eb_usersanonymous(id);
CREATE INDEX eb_usersanonymous_socialid_idx ON eb_usersanonymous(socialid);
CREATE INDEX eb_usersanonymous_email_idx ON eb_usersanonymous(email);

