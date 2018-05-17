BEGIN
	EXECUTE IMMEDIATE 'create or replace type authenticate_res_obj as object (
			userid integer, 
			email varchar(30),
			fullname varchar(30),
			roles_a clob,
			rolename_a clob,
			permissions clob,
			preferencesjson clob
		)';

	EXECUTE IMMEDIATE 'create or replace type authenticate_res_tbl as table of authenticate_res_obj';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE returnpermission_obj as object (
		permissioname clob
	)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE returnpermission_tbl as table of returnpermission_obj'; 

	EXECUTE IMMEDIATE 'create or replace type tblroleobj as object (
	  rid varchar(30),
	  rname varchar2(30)
	)';
	EXECUTE IMMEDIATE 'create or replace type rtntblrole as table of tblroleobj';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE TAG_RECORD AS OBJECT(
		obj_name CLOB,
		refid CLOB,
		version_num CLOB,
		obj_type NUMBER,
		status NUMBER
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE TAG_TABLE AS TABLE OF TAG_RECORD';

	
	EXECUTE IMMEDIATE 'create or replace type obj_explore_record as object (
	  idval number,
	  nameval CLOB,
	  typeval number, 
	  statusval number, 
	  descriptionval CLOB,
	  changelogval CLOB,
	  commitatval TIMESTAMP,
	  commitbyval CLOB,
	  refidval CLOB,
	  ver_numval CLOB,
	  work_modeval char,
	  workingcopiesval CLOB,
	  json_wcval CLOB,
	  json_lcval CLOB,
	  major_verval number,
	  minor_verval number,
	  patch_verval number,
	  tagsval CLOB, 
	  app_idval CLOB,
	  lastversionrefidval CLOB,
	  lastversionnumberval CLOB,
	  lastversioncommit_tsval TIMESTAMP,
	  lastversion_statusval number,
	  lastversioncommit_byname CLOB,
	  lastversioncommit_byid number,
	  liveversionrefidval CLOB,
	  liveversionnumberval CLOB,
	  liveversioncommit_tsval TIMESTAMP,
	  liveversion_statusval number,
	  liveversioncommit_byname CLOB,
	  liveversioncommit_byid number,
	  owner_uidval number,
	  owner_tsval TIMESTAMP,
	  owner_nameval CLOB 
	)';


	EXECUTE IMMEDIATE 'create or replace type obj_explore_table as table of obj_explore_record';

	EXECUTE IMMEDIATE 'create or replace type GET_VERSION_RECORD as object (
	  idv NUMBER,
	  namev CLOB, 
	  typev NUMBER, 
	  status NUMBER, 
	  description CLOB,
	  changelog CLOB,
	  commitat TIMESTAMP,
	  commitby CLOB,
	  refidv CLOB,
	  ver_num CLOB,
	  work_mode CHAR,
	  workingcopies CLOB, 
	  json_wc CLOB, 
	  json_lc CLOB,
	  major_ver NUMBER,
	  minor_ver NUMBER,
	  patch_ver NUMBER,
	  tags CLOB, 
	  app_id CLOB
	)';

	EXECUTE IMMEDIATE 'create or replace type GET_VERSION_TABLE as table of GET_VERSION_record';

	EXECUTE IMMEDIATE 'create or replace type obj_dashboard_record as object (
	  namev CLOB,
	  status1 number,
	  ver_num CLOB,
	  work_mode char, 
	  workingcopies clob, 
	  major_ver number,
	  minor_ver number, 
	  patch_ver number, 
	  tags CLOB,
	  app_id CLOB,
	  lastversionrefidval CLOB,
	  lastversionnumberval CLOB,
	  lastversioncommit_tsval TIMESTAMP,
	  lastversion_statusval number,
	  lastversioncommit_byname CLOB, 
	  lastversioncommit_byid number,
	  liveversionrefidval CLOB,
	  liveversionnumberval CLOB,
	  liveversioncommit_tsval TIMESTAMP,
	  liveversion_statusval number,
	  liveversioncommit_byname CLOB,
	  liveversioncommit_byid number,
	  owner_uidval number, 
	  owner_tsval TIMESTAMP,
	  owner_nameval CLOB
	)';
	

	EXECUTE IMMEDIATE 'create or replace type obj_dashboard_table as table of obj_dashboard_record';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TYPE APPTYPE is varray(100) of NUMERIC(10)';




END;