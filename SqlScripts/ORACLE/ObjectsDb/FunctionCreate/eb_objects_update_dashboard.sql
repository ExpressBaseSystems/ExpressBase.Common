create or replace FUNCTION eb_objects_update_dashboard(
	refid_ varchar)
    RETURN obj_dashboard_table
AS
    
    dashboard_tbl obj_dashboard_table := obj_dashboard_table();
    workingcopies clob; id_ number;
    namev CLOB; status1 number;
	description CLOB; changelog CLOB; ver_num CLOB; work_mode char;
	major_ver number; minor_ver number; patch_ver number; tags CLOB; app_id CLOB;
	lastversionrefidval CLOB; lastversionnumberval CLOB; lastversioncommit_tsval TIMESTAMP;
	lastversion_statusval number; lastversioncommit_byname CLOB; lastversioncommit_byid number; liveversionrefidval CLOB;
	liveversionnumberval CLOB; liveversioncommit_tsval TIMESTAMP; liveversion_statusval number; liveversioncommit_byname CLOB;
	liveversioncommit_byid number; owner_uidVal number; owner_tsVal TIMESTAMP; owner_nameVal CLOB;
    count_num NUMBER;

BEGIN
	workingcopies := NULL;

SELECT eb_objects_id INTO id_ FROM eb_objects_ver WHERE refid = refid_;

select LISTAGG(EA.applicationname,',') WITHIN GROUP(ORDER BY EA.applicationname) INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = id_ and E2O.eb_del = 'F' and EA.id = E2O.app_id ;

 ---------------------------------
 SELECT COUNT(*) INTO count_num FROM eb_objects_ver WHERE eb_objects_id=id_ AND working_mode='T';
 IF count_num=0 THEN
    workingcopies := NULL;
ELSE
    SELECT 
        LISTAGG(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('{','"'),version_num),'"'),':'),'"'),refid),'"'),'}'),',')
        WITHIN GROUP(ORDER BY version_num)   INTO  workingcopies
    FROM 
        eb_objects_ver 
    WHERE 
        eb_objects_id=id_ AND working_mode='T';
END IF;

--Live version details----------------------
SELECT COUNT(*) INTO count_num FROM eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU WHERE
    EO.id = id_ AND EOV.eb_objects_id = id_ AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
IF count_num=0 THEN
    liveversionnumberval:=''; liveversionrefidval:='';
    liveversioncommit_tsval:=null; liveversion_statusval:=0;
    liveversioncommit_byid:=0; liveversioncommit_byname:='';
ELSE
    SELECT
        EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
        liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname
    FROM
        eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
    WHERE
    EO.id = id_ AND EOV.eb_objects_id = id_ AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
END IF;

--Latest commited vaersion details--------
SELECT COUNT(*) INTO count_num FROM eb_objects_ver EOV, eb_objects_status EOS, eb_users EU WHERE EOV.eb_objects_id = id_ AND 
    EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F' AND ROWNUM<=1 ORDER BY commit_ts DESC;
IF count_num=0 THEN
    lastversionnumberval:=''; lastversionrefidval:='';
    lastversioncommit_tsval:=null; lastversion_statusval:=0;
    lastversioncommit_byname:=''; lastversioncommit_byid:=0;
ELSE
    SELECT EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid
    FROM eb_objects_ver EOV, eb_objects_status EOS, eb_users EU WHERE EOV.eb_objects_id = id_ AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    AND ROWNUM<=1 ORDER BY commit_ts DESC;
END IF;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
INTO 
	owner_uidVal, owner_tsVal, owner_nameVal
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = id_ AND EU.id = EO.owner_uid;


SELECT 
			EO.obj_name, EOS.status,EOV.version_num, EOV.working_mode,
		    EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
	INTO	namev, status1, ver_num, work_mode,
			 major_ver, minor_ver, patch_ver, tags
	FROM 
			 eb_objects EO, eb_objects_ver EOV
    LEFT JOIN
		eb_users EU
	ON 
		EOV.commit_uid=EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id	
	WHERE 
			EOV.refid = refid_ AND EOV.eb_objects_id = EO.id
    AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);

    --RETURN 
    dashboard_tbl.extend();
    dashboard_tbl(1) := obj_dashboard_record(namev, status1, ver_num,
	COALESCE(work_mode,'F'), workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal);


	RETURN dashboard_tbl;
END;



