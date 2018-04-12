create or replace FUNCTION eb_objects_exploreobject(
	id_ NUMBER)
    RETURN obj_explore_table as explore_obj obj_explore_table;
    --TABLE(idval integer,  text, typeval integer, statusval integer, descriptionval text, changelogval text, commitatval text, commitbyval text, refidval text, ver_numval text, work_modeval boolean, workingcopiesval text[], json_wcval json, json_lcval json, major_verval integer, minor_verval integer, patch_verval integer, tagsval text, app_idval text, lastversionrefidval text, lastversionnumberval text, lastversioncommit_tsval text, lastversion_statusvalv integer, lastversioncommit_byname text, lastversioncommit_byid integer, liveversionrefidval text, liveversionnumberval text, liveversioncommit_tsval text, liveversion_statusval integer, liveversioncommit_byname text, liveversioncommit_byid integer, owner_uidval integer, owner_tsval text, owner_nameval text) 

	workingcopiesval CLOB;
	json_wcval CLOB; json_lcval CLOB;
	idval number; nameval CLOB; typeval number; statusval number;
	descriptionval CLOB; changelogval CLOB; commitatval TIMESTAMP; commitbyval CLOB; refidval CLOB; ver_numval CLOB; work_modeval char;
	major_verval number; minor_verval number; patch_verval number; tagsval CLOB; app_idval CLOB;
	lastversionrefidval CLOB; lastversionnumberval CLOB; lastversioncommit_tsval TIMESTAMP; lastversion_statusval number; lastversioncommit_byname CLOB;lastversioncommit_byid number;
	liveversionrefidval CLOB; liveversionnumberval CLOB; liveversioncommit_tsval TIMESTAMP; liveversion_statusval number; liveversioncommit_byname CLOB;liveversioncommit_byid number;
	owner_uidVal number; owner_tsVal TIMESTAMP; owner_nameVal CLOB;
    countnum number; 
BEGIN

--Live version details
SELECT count(*) INTO countnum FROM eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
    WHERE EO.id = id_ AND EOV.eb_objects_id = id_ AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;

IF countnum=0 THEN
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

--Latest commited vaersion details
SELECT count(*) INTO countnum FROM eb_objects_ver EOV, eb_objects_status EOS, eb_users EU WHERE EOV.eb_objects_id = 51 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    AND ROWNUM<=1 ORDER BY commit_ts DESC;

IF countnum=0 THEN
    lastversionnumberval:=''; lastversionrefidval:='';
    lastversioncommit_tsval:=null; lastversion_statusval:=0;
    lastversioncommit_byname:=''; lastversioncommit_byid:=0;
ELSE
    SELECT
        EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid
    FROM
        eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
    WHERE
        EOV.eb_objects_id = id_ AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
        AND ROWNUM<=1 ORDER BY commit_ts DESC;
END IF;

-- Owner details

    SELECT  EO.owner_uid, EO.owner_ts, EU.firstname INTO owner_uidVal, owner_tsVal, owner_nameVal
    FROM eb_objects EO, eb_users EU WHERE EO.id = id_ AND EU.id = EO.owner_uid;

    SELECT idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,'F'), workingcopies,
		json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id 
    INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval,
		json_wcval, json_lcval, major_verval, minor_verval, patch_verval, tagsval, app_idval
    FROM 
		table(eb_objects_getversiontoopen(id_)) ;

        select obj_explore_record(
        idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal)bulk collect into explore_obj from dual;


RETURN explore_obj;	
END;