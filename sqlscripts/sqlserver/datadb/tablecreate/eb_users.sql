CREATE SEQUENCE eb_users_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_users
(
    id int default(NEXT VALUE FOR eb_users_id_seq) primary key,
    email varchar(100) ,
    pwd varchar(100) ,
    firstname varchar(max) ,
    lastname varchar(max) ,
    middlename varchar(max) ,
    dob date,
    phnoprimary varchar(max) ,
    phnosecondary varchar(max) ,
    landline varchar(max) ,
    phextension varchar(max) ,    
    alternateemail varchar(max) , 
    profileimg varchar(max) ,
    slackjson nvarchar(max),
    prolink varchar(max) ,
    loginattempts int DEFAULT 1,
    socialid varchar(max) ,
    socialname varchar(max) ,
    fullname varchar(max) ,
    nickname varchar(max) ,
    sex varchar(max) ,
    fbid varchar(max) ,
    fbname varchar(max) ,
    preferencesjson varchar(max) ,
    createdby varchar(max) ,
    createdat varchar(max) ,
    statusid int DEFAULT 0,
    hide varchar(max) ,
    eb_del char NOT NULL DEFAULT 'F',
    dprefid int DEFAULT 0,
    eb_ver_id int,
    eb_data_id int,
    CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_users_id_idx ON eb_users(id);
CREATE INDEX eb_users_eb_del_idx ON eb_users(eb_del);
CREATE INDEX eb_users_email_idx ON eb_users(email);
CREATE INDEX eb_users_pwd_idx ON eb_users(pwd);
CREATE INDEX eb_users_statusid_idx ON eb_users(statusid);