-- DROP TABLE eb_usersanonymous;

CREATE TABLE eb_usersanonymous
(
    id integer NOT NULL auto_increment,
    fullname varchar(255),
    socialid varchar(255),
    email varchar(255),
    sex varchar(20),
    phoneno varchar(20),
    firstvisit date,
    lastvisit date,
    appid INT,
    totalvisits INT DEFAULT 1,
    ebuserid INT DEFAULT 1,
    modifiedby INT,
    modifiedat date,
    remarks varchar(50),
    ipaddress varchar(20),
    browser varchar(50),
    city varchar(50),
    region varchar(50),
    country varchar(50),
    latitude varchar(50),
    longitude varchar(50),
    timezone varchar(50),
    iplocationjson longtext,
    PRIMARY KEY (id)
);

-- Index: eb_usersanonymous_email_idx

-- DROP INDEX eb_usersanonymous_email_idx;

CREATE INDEX eb_usersanonymous_email_idx
    ON eb_usersanonymous (email );

-- Index: eb_usersanonymous_id_idx

-- DROP INDEX eb_usersanonymous_id_idx;

CREATE INDEX eb_usersanonymous_id_idx
    ON eb_usersanonymous (id);

-- Index: eb_usersanonymous_socialid_idx

-- DROP INDEX eb_usersanonymous_socialid_idx;

CREATE INDEX eb_usersanonymous_socialid_idx
    ON eb_usersanonymous (socialid);