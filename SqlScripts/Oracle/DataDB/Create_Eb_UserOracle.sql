DECLARE
eb_del varchar(10);  
d_format varchar(20);
timezone varchar(20);
numformat varchar(20);

BEGIN
  eb_del := 'F'; 
  d_format := 'DD/MM/YYYY';
  timezone := 'UTC+05:30';
  numformat := '0,000.00';

EXECUTE IMMEDIATE 'CREATE TABLE eb_role2role
(
    id integer,
    role1_id number,
    role2_id number,
    eb_del char DEFAULT '''|| eb_del ||''',
    createdby number,
    createdat timestamp,
    revokedby number,
    revokedat timestamp,
    CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_role2permission
(
    id integer NOT NULL,
    role_id integer,
    eb_del char DEFAULT '''|| eb_del ||''',
    permissionname varchar(20),
    createdby integer,
    createdat timestamp,
    obj_id integer,
    op_id integer,
    revokedby integer,
    revokedat timestamp,
    CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_role2user
(
    id integer NOT NULL,
    role_id integer,
    user_id integer,
    eb_del char DEFAULT '''|| eb_del ||''',
    createdby integer,
    createdat timestamp,
    revokedby integer,
    revokedat timestamp,
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_roles
(
    id integer NOT NULL,
    role_name varchar(20),
    eb_del char,
    applicationname varchar(50),
    applicationid integer,
    description varchar(200),
    CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    CONSTRAINT eb_rolename_unique UNIQUE (role_name)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_user2usergroup
(
    id integer NOT NULL,
    userid integer,
    groupid integer,
    eb_del char DEFAULT '''|| eb_del ||''',
    createdby integer,
    createdat timestamp,
    revokedby integer,
    revokedat timestamp,
    CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_usergroup
(
    id integer NOT NULL,
    name varchar(30),
    description varchar(200),
    eb_del char,
    CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id)
)';

EXECUTE IMMEDIATE 'CREATE TABLE eb_users
(
    id integer NOT NULL,
    email varchar(50),
    pwd varchar(20),
    eb_del char DEFAULT '''|| eb_del ||''',
    firstname varchar(20),
    lastname varchar(20),
    middlename varchar(20),
    dob date,
    phnoprimary varchar(20),
    phnosecondary varchar(20),
    landline varchar(20),
    extension varchar(20),
    locale varchar(30),
    alternateemail varchar(50),
    dateformat varchar(20) DEFAULT '''|| d_format ||''',
    timezone varchar(20) DEFAULT '''|| timezone ||''',
    numformat varchar(20) DEFAULT ''' || numformat ||''',
    timezoneabbre varchar(20),
    timezonefull varchar(20),
    profileimg varchar(20),
    slackjson varchar(50),
    u_token varchar(25),
    socialid varchar(30),
    prolink varchar(50),
    loginattempts integer DEFAULT 1,
    company varchar(50),
    employees varchar(30),
    designation varchar(30),
    country varchar(30),
    CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    CONSTRAINT socialid_unique_key UNIQUE (socialid)
)';