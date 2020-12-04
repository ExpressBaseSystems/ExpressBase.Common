CREATE SEQUENCE eb_files_ref_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_files_ref
(
    id int default(NEXT VALUE FOR eb_files_ref_id_seq) primary key,
    userid int NOT NULL,
	filename varchar(max),
	tags varchar(max) ,
	filetype varchar(max) ,
    uploadts datetime2(6),
    eb_del "char" NOT NULL DEFAULT 'F',
    filecategory int,
    context varchar(max),
	lastmodifiedby integer,
	lastmodifiedat datetime2(6),
    CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_files_ref_id_idx ON eb_files_ref(id);
CREATE INDEX eb_files_ref_userid_idx ON eb_files_ref(userid);

