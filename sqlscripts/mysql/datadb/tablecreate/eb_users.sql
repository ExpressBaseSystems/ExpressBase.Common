
-- DROP TABLE eb_users;

CREATE TABLE eb_users
(
    id INT NOT NULL  AUTO_INCREMENT,
    email VARCHAR(50),
    pwd VARCHAR(50),
    firstname LONGTEXT,
    lastname LONGTEXT,
    middlename LONGTEXT,
    dob DATE,
    phnoprimary VARCHAR(20),
    phnosecondary VARCHAR(20),
    landline VARCHAR(20),
    phextension VARCHAR(20),
    locale VARCHAR(50),
    alternateemail VARCHAR(50),
    dateformat VARCHAR(50) DEFAULT 'DD/MM/YYYY',
    timezone VARCHAR(50) DEFAULT 'UTC+05:30',
    numformat VARCHAR(50) DEFAULT '0,000.00',
    timezoneabbre VARCHAR(50),
    timezonefull VARCHAR(50),
    profileimg VARCHAR(50),
    slackjson VARCHAR(50),
    prolink VARCHAR(50),
    loginattempts INT DEFAULT 1,
    socialid VARCHAR(50),
    socialname VARCHAR(50),
    fullname VARCHAR(50),
    nickname VARCHAR(50),
    sex VARCHAR(50),
    fbid VARCHAR(50),
    fbname VARCHAR(50),
    preferencesjson VARCHAR(50),
    createdby VARCHAR(50),
    createdat VARCHAR(50),
    statusid INT DEFAULT 0,
    hide VARCHAR(50),
    eb_del char(1) NOT NULL DEFAULT 'F',
    PRIMARY KEY (id),
    CHECK (eb_del = 'T' OR eb_del = 'F')
);

-- Index: eb_users_eb_del_idx

-- DROP INDEX public.eb_users_eb_del_idx;

CREATE INDEX eb_users_eb_del_idx
    ON eb_users (eb_del);

-- Index: eb_users_email_idx

-- DROP INDEX public.eb_users_email_idx;

CREATE INDEX eb_users_email_idx
    ON eb_users (email );

-- Index: eb_users_id_idx

-- DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX eb_users_id_idx
    ON eb_users (id);

-- Index: eb_users_pwd_idx

-- DROP INDEX public.eb_users_pwd_idx;

CREATE INDEX eb_users_pwd_idx
    ON eb_users (pwd );

-- Index: eb_users_statusid_idx

-- DROP INDEX public.eb_users_statusid_idx;

CREATE INDEX eb_users_statusid_idx
    ON eb_users (statusid);
