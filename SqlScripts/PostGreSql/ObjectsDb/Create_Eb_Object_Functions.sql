-- FUNCTION: public.cur_val(text)

-- DROP FUNCTION public.cur_val(text);

--CREATE OR REPLACE FUNCTION public.cur_val(
--	text)
--    RETURNS integer
--    LANGUAGE 'plpgsql'
    
--AS $BODY$

--DECLARE seq ALIAS FOR $1;
--DECLARE result integer;
--BEGIN
--result := 0;
--EXECUTE 'SELECT currval(''' || seq || ''')' INTO result;
--RETURN result;
--EXCEPTION WHEN OTHERS THEN
----do nothing
--RETURN result;
--END;

--$BODY$;

--ALTER FUNCTION public.cur_val(text)
--    OWNER TO postgres;

-- FUNCTION: public.eb_objects_change_status(text, integer, integer, text)

-- DROP FUNCTION public.eb_objects_change_status(text, integer, integer, text);

CREATE OR REPLACE FUNCTION public.eb_objects_change_status(
	idv text,
	statusv integer,
	commit_uid integer,
	changelogv text)
    RETURNS SETOF void 
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE inserted_obj_ver_id integer;
BEGIN 
  
INSERT INTO
	eb_objects_status(eb_obj_ver_id)
SELECT
	id
FROM
	eb_objects_ver
WHERE
	refid=idv
RETURNING
	id INTO inserted_obj_ver_id;

UPDATE
	eb_objects_status 
SET
	status = statusv, uid = commit_uid, ts = NOW(), changelog = changelogv
WHERE
	id = inserted_obj_ver_id;
RETURN;
END;

$BODY$;

ALTER FUNCTION public.eb_objects_change_status(text, integer, integer, text)
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_commit(text, text, text, integer, json, text, integer, text, text, text[], text, integer[])

-- DROP FUNCTION public.eb_objects_commit(text, text, text, integer, json, text, integer, text, text, text[], text, integer[]);

CREATE OR REPLACE FUNCTION public.eb_objects_commit(
	idv text,
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_jsonv json,
	obj_changelogv text,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[],
	tagsv text,
	apps integer[])
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
AS $BODY$

DECLARE refidunique text; inserted_obj_ver_id integer; objid integer; committed_refidunique text; major integer; minor integer; patch integer; version_number text;

BEGIN

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch FROM eb_objects_ver WHERE refid=idv;

  	UPDATE eb_objects 
	SET 
    	obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv
	WHERE 
    	id = objid; 
		
	UPDATE eb_objects_ver
	SET
    	obj_json = obj_jsonv, obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = NOW()
	WHERE
    	--eb_objects_id= objid AND major_ver_num=major AND working_mode=true 
		refid = idv RETURNING id INTO inserted_obj_ver_id;
    
    refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
     committed_refidunique:=refidunique;
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  
	
	--majorversion.minorversion.patchversion
	version_number := CONCAT_WS('.', major, minor, patch);
   UPDATE eb_objects_ver SET version_num = version_number, working_mode = false WHERE refid = refidunique;

   --relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
        EXCEPT 
            SELECT unnest(ARRAY[relationsv]));
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidunique 
      FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        EXCEPT 
      SELECT unnest(array(select dominant from eb_objects_relations 
                            WHERE dependant = refidunique )))) as dominantvals;  

--application table
UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
        SELECT unnest(ARRAY(select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')) 
        EXCEPT 
        SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])]));
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		appvals, objid
      	FROM UNNEST(array(SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])])
        EXCEPT 
      	SELECT unnest(array(select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')))) as appvals;
									
    RETURN committed_refidunique; 	

END;

$BODY$;

ALTER FUNCTION public.eb_objects_commit(text, text, text, integer, json, text, integer, text, text, text[], text, integer[])
    OWNER TO postgres;



-- FUNCTION: public.eb_objects_create_major_version(text, integer, integer, text, text, text[])

-- DROP FUNCTION public.eb_objects_create_major_version(text, integer, integer, text, text, text[]);

CREATE OR REPLACE FUNCTION public.eb_objects_create_major_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[])
    RETURNS text
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE refidunique text; inserted_obj_ver_id integer; objid integer; committed_refidunique text; major integer; version_number text;

BEGIN
SELECT eb_objects_id into objid FROM eb_objects_ver WHERE refid = idv;
	SELECT MAX(major_ver_num) into major from eb_objects_ver WHERE eb_objects_id = objid;

	INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json)
	SELECT
		eb_objects_id,obj_json
	FROM 
		eb_objects_ver
	WHERE
		refid=idv
   RETURNING id INTO inserted_obj_ver_id;
   
		
		version_number := CONCAT_WS('.', major+1, 0, 0, 'w');
		
	UPDATE eb_objects_ver
		SET
		commit_ts = NOW(), commit_uid = commit_uidv, version_num = version_number, working_mode = true, major_ver_num = major+1, minor_ver_num = 0, patch_ver_num = 0
	WHERE
			id = inserted_obj_ver_id ;
	

    refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
     committed_refidunique:=refidunique;
     
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;    
    
    INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());
    
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by= commit_uidv , removed_at=NOW()
      WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
        EXCEPT 
            SELECT unnest(ARRAY[relationsv]));
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidunique 
      FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        EXCEPT 
      SELECT unnest(array(select dominant from eb_objects_relations 
                            WHERE dependant = refidunique )))) as dominantvals;                            
    RETURN committed_refidunique; 	

END;

$BODY$;

ALTER FUNCTION public.eb_objects_create_major_version(text, integer, integer, text, text, text[])
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_create_minor_version(text, integer, integer, text, text, text[])

-- DROP FUNCTION public.eb_objects_create_minor_version(text, integer, integer, text, text, text[]);

CREATE OR REPLACE FUNCTION public.eb_objects_create_minor_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[])
    RETURNS text
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE refidunique text; inserted_objid integer; inserted_obj_ver_id integer; objid integer; committed_refidunique text; minor integer;major integer; version_number text;

BEGIN

	SELECT eb_objects_id, major_ver_num into objid, major FROM eb_objects_ver WHERE refid=idv;
	SELECT MAX(minor_ver_num) into minor FROM eb_objects_ver WHERE eb_objects_id = objid AND major_ver_num = major;

	INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json, major_ver_num)
	SELECT
		eb_objects_id,obj_json,major_ver_num
	FROM 
		eb_objects_ver
	WHERE
		refid=idv
   RETURNING id INTO inserted_obj_ver_id;
		
		version_number := CONCAT_WS('.', major, minor+1, 0, 'w');
		
	UPDATE eb_objects_ver
		SET
		commit_ts = NOW(), commit_uid = commit_uidv, version_num = version_number, working_mode = true, minor_ver_num = minor+1, patch_ver_num = 0
	WHERE
			id = inserted_obj_ver_id ;
	

    refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
     committed_refidunique:=refidunique;
     
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
    
    INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());
    
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
        EXCEPT 
            SELECT unnest(ARRAY[relationsv]));
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidunique 
      FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        EXCEPT 
      SELECT unnest(array(select dominant from eb_objects_relations 
                            WHERE dependant = refidunique )))) as dominantvals;                            
    RETURN committed_refidunique; 	

END;

$BODY$;

ALTER FUNCTION public.eb_objects_create_minor_version(text, integer, integer, text, text, text[])
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text[], boolean, text, integer[])

-- DROP FUNCTION public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text[], boolean, text, integer[]);

CREATE OR REPLACE FUNCTION public.eb_objects_create_new_object(
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_cur_statusv integer,
	obj_jsonv json,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[],
	issave boolean,
	tagsv text,
	apps integer[])
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
AS $BODY$

DECLARE refidunique text; inserted_objid integer; inserted_obj_ver_id integer; refid_of_commit_version text; version_number text;
BEGIN   
    INSERT INTO eb_objects 
        (obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts)
    VALUES
        (obj_namev, obj_descv, obj_typev, obj_cur_statusv, tagsv, commit_uidv, NOW()) RETURNING id INTO inserted_objid;

    INSERT INTO eb_objects_ver
        (eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
    VALUES
        (inserted_objid, obj_jsonv, commit_uidv, NOW(),1,0,0,issave)RETURNING id INTO inserted_obj_ver_id;
		
    --majorversion.minorversion.patchversion
    IF issave = TRUE THEN
		version_number := CONCAT_WS('.',1,0,0,'w');
    ELSE
    	version_number := CONCAT_WS('.',1,0,0);
    END IF;
	
	--source_pid-current_pid-object_type-objectid-object_ver_id 
    refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id); 
	
    refid_of_commit_version:=refidunique;                       
	UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;
    
	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts, changelog) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW(), 'Created');
	
    --relations table
    INSERT INTO eb_objects_relations (dominant,dependant) VALUES (UNNEST(relationsv),refidunique);
	
	--applications table
	INSERT INTO eb_objects2application (app_id,obj_id) VALUES (UNNEST(apps),inserted_objid);
		
	RETURN refid_of_commit_version;
END;

$BODY$;

ALTER FUNCTION public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text[], boolean, text, integer[])
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_create_patch_version(text, integer, integer, text, text, text[])

-- DROP FUNCTION public.eb_objects_create_patch_version(text, integer, integer, text, text, text[]);

CREATE OR REPLACE FUNCTION public.eb_objects_create_patch_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[])
    RETURNS text
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE refidunique text; inserted_obj_ver_id integer; objid integer; committed_refidunique text; major integer; minor integer; patch integer; version_number text;

BEGIN

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch  FROM eb_objects_ver WHERE refid=idv;
	
INSERT INTO 
	eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
SELECT
	eb_objects_id, obj_json, major_ver_num, minor_ver_num
FROM 
	eb_objects_ver
WHERE
	refid=idv
RETURNING id INTO inserted_obj_ver_id;

	version_number := CONCAT_WS('.', major, minor, patch + 1,'w');
	
UPDATE eb_objects_ver
	SET
	commit_ts = NOW(), Commit_uid = commit_uidv, version_num = version_number, working_mode = true, patch_ver_num = patch + 1
WHERE
		id = inserted_obj_ver_id ;

	refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
	committed_refidunique:=refidunique;

UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;

INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());

UPDATE eb_objects_relations 
SET 
	eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
WHERE 
	dominant IN(
	SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
	EXCEPT 
	SELECT unnest(ARRAY[relationsv]));
		
INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
	  dominantvals, refidunique 
	FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
	EXCEPT 
	SELECT unnest(array(select dominant from eb_objects_relations 
							WHERE dependant = refidunique )))) as dominantvals;                            
RETURN committed_refidunique; 	

END;

$BODY$;

ALTER FUNCTION public.eb_objects_create_patch_version(text, integer, integer, text, text, text[])
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_exploreobject(integer)

-- DROP FUNCTION public.eb_objects_exploreobject(integer);

CREATE OR REPLACE FUNCTION public.eb_objects_exploreobject(
	_id integer)
    RETURNS TABLE(idval integer, nameval text, typeval integer, statusval integer, descriptionval text, changelogval text, commitatval text, commitbyval text, refidval text, ver_numval text, work_modeval boolean, workingcopiesval text[], json_wcval json, json_lcval json, major_verval integer, minor_verval integer, patch_verval integer, tagsval text, app_idval text, lastversionrefidval text, lastversionnumberval text, lastversioncommit_tsval text, lastversion_statusvalv integer, lastversioncommit_byname text, lastversioncommit_byid integer, liveversionrefidval text, liveversionnumberval text, liveversioncommit_tsval text, liveversion_statusval integer, liveversioncommit_byname text, liveversioncommit_byid integer, owner_uidval integer, owner_tsval text, owner_nameval text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE
	workingcopiesval text[];
	json_wcval json; json_lcval json;
	idval integer; nameval text; typeval integer; statusval integer;
	descriptionval text; changelogval text; commitatval text; commitbyval text; refidval text; ver_numval text; work_modeval boolean;
	major_verval integer; minor_verval integer; patch_verval integer; tagsval text; app_idval text;
	lastversionrefidval text; lastversionnumberval text; lastversioncommit_tsval text; lastversion_statusval integer; lastversioncommit_byname text;lastversioncommit_byid integer;
	liveversionrefidval text; liveversionnumberval text; liveversioncommit_tsval text; liveversion_statusval integer; liveversioncommit_byname text;liveversioncommit_byid integer;
	owner_uidVal integer; owner_tsVal text; owner_nameVal text;
 
BEGIN

--Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
	
--Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,false) = false
    ORDER BY commit_ts DESC LIMIT 1;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
INTO 
	owner_uidVal, owner_tsVal, owner_nameVal
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid;
	
SELECT idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,false), workingcopies,
		json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id
    FROM 
		eb_objects_getversiontoopen(_id) 
	INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval,
		json_wcval, json_lcval, major_verval, minor_verval, patch_verval, tagsval, app_idval;
	
RETURN QUERY
	SELECT idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal;
END

$BODY$;

ALTER FUNCTION public.eb_objects_exploreobject(integer)
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_getversiontoopen(integer)

-- DROP FUNCTION public.eb_objects_getversiontoopen(integer);

CREATE OR REPLACE FUNCTION public.eb_objects_getversiontoopen(
	_id integer)
    RETURNS TABLE(idv integer, namev text, typev integer, status integer, description text, changelog text, commitat text, commitby text, refidv text, ver_num text, work_mode boolean, workingcopies text[], json_wc json, json_lc json, major_ver integer, minor_ver integer, patch_ver integer, tags text, app_id text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE
    workingcopies text[];
	json_wc json; json_lc json; no_of_workcopies integer;
	idv integer; namev text; typev integer; status integer;
	description text; changelog text; commitat text; commitby text; refidv text; ver_num text; work_mode boolean;
	major_ver integer; minor_ver integer; patch_ver integer; tags text; app_id text;
	lastversionnumber text; lastversionrefid text; liveversionnumber text; liveversionrefid text;
BEGIN

	workingcopies := NULL;
	json_wc := NULL;
	json_lc :=NULL;
--Fetching all working copies
SELECT 
	string_to_array(string_agg((json_build_object( version_num, refid)::text),','),',') INTO workingcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode=true;
			
no_of_workcopies := COALESCE(array_length(workingcopies, 1), 0);

 select string_agg(EA.applicationname,',') INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = _id and E2O.eb_del = 'F' and EA.id = E2O.app_id ;

--one working copy	
IF no_of_workcopies = 1 THEN
	SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
	INTO	idv, namev, typev, status, description, json_wc, changelog, commitat, refidv, ver_num, work_mode, commitby,
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
			EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode=true
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
			
--No working copy			
ELSIF no_of_workcopies = 0 THEN
        SELECT 
                EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc, 
                EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
				EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
        INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
				commitby, major_ver, minor_ver, patch_ver, tags
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
                EO.id = _id AND EOV.eb_objects_id = EO.id  AND
                major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=_id) AND 
                minor_ver_num=(Select max(minor_ver_num) from eb_objects_ver where eb_objects_id=_id AND  
				major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=_id)) AND
                COALESCE(working_mode, FALSE) <> true
				AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);    
				
 -- multiple workingcopies
ELSE
SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags, EOS.id
	 INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
			commitby, major_ver, minor_ver, patch_ver, tags
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
		EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode=true
		AND EOV.id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = _id AND working_mode=true)
		AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS, eb_objects_ver EOV WHERE EOS.eb_obj_ver_id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = _id AND working_mode=true) AND EOV.working_mode=true);
END IF;

RETURN QUERY
	SELECT idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,false), workingcopies,
	json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id;
END

$BODY$;

ALTER FUNCTION public.eb_objects_getversiontoopen(integer)
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_save(text, text, text, integer, json, integer, text, text, text[], text, integer[])

-- DROP FUNCTION public.eb_objects_save(text, text, text, integer, json, integer, text, text, text[], text, integer[]);

CREATE OR REPLACE FUNCTION public.eb_objects_save(
	refidv text,
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_jsonv json,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsv text[],
	tagsv text,
	apps integer[])
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
AS $BODY$

DECLARE refidunique text; inserted_objid integer; inserted_obj_ver_id integer; objid integer;
BEGIN
SELECT eb_objects_id FROM eb_objects_ver into objid WHERE refid=refidv;
 	UPDATE eb_objects SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv WHERE id = objid RETURNING id INTO inserted_objid;
    UPDATE eb_objects_ver SET obj_json = obj_jsonv WHERE refid=refidv RETURNING id INTO inserted_obj_ver_id;
    
    refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id);                                 
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
    
    --relations table
	UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        dominant IN(
        SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
        EXCEPT 
        SELECT unnest(ARRAY[relationsv]));
            
        INSERT INTO eb_objects_relations (dominant, dependant) 
        SELECT 
     		dominantvals, refidunique
      	FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        EXCEPT 
      	SELECT unnest(array(select dominant from eb_objects_relations WHERE dependant = refidunique )))) as dominantvals;

--applications table 
  UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
        SELECT unnest(ARRAY(select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')) 
        EXCEPT 
        SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])]));
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		appvals, inserted_objid
      	FROM UNNEST(array(SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])])
        EXCEPT 
      	SELECT unnest(array(select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')))) as appvals;
        
  RETURN refidunique;
END;

$BODY$;

ALTER FUNCTION public.eb_objects_save(text, text, text, integer, json, integer, text, text, text[], text, integer[])
    OWNER TO postgres;


-- FUNCTION: public.eb_objects_update_dashboard(text)

-- DROP FUNCTION public.eb_objects_update_dashboard(text);

CREATE OR REPLACE FUNCTION public.eb_objects_update_dashboard(
	_refid text)
    RETURNS TABLE(namev text, status integer, ver_num text, work_mode boolean, workingcopies text[], major_ver integer, minor_ver integer, patch_ver integer, tags text, app_id text, lastversionrefidval text, lastversionnumberval text, lastversioncommit_tsval text, lastversion_statusval integer, lastversioncommit_byname text, lastversioncommit_byid integer, liveversionrefidval text, liveversionnumberval text, liveversioncommit_tsval text, liveversion_statusval integer, liveversioncommit_byname text, liveversioncommit_byid integer, owner_uidval integer, owner_tsval text, owner_nameval text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE
	workingcopies text[]; _id integer;
    namev text; status integer;
	description text; changelog text; ver_num text; work_mode boolean;
	major_ver integer; minor_ver integer; patch_ver integer; tags text; app_id text;
	lastversionrefidval text; lastversionnumberval text; lastversioncommit_tsval text;
	lastversion_statusval integer; lastversioncommit_byname text; lastversioncommit_byid integer; liveversionrefidval text;
	liveversionnumberval text; liveversioncommit_tsval text; liveversion_statusval integer; liveversioncommit_byname text;
	liveversioncommit_byid integer; owner_uidVal integer; owner_tsVal text; owner_nameVal text;
 
BEGIN

	workingcopies := NULL;

SELECT eb_objects_id INTO _id FROM eb_objects_ver WHERE refid = _refid;

select string_agg(EA.applicationname,',') INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = _id and E2O.eb_del = 'F' and EA.id = E2O.app_id ;
 
SELECT 
	string_to_array(string_agg((json_build_object( version_num, refid)::text),','),',') INTO workingcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode=true;

--Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
	
--Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,false) = false
    ORDER BY commit_ts DESC LIMIT 1;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
INTO 
	owner_uidVal, owner_tsVal, owner_nameVal
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid;
	

	SELECT 
			EO.obj_name, EOS.status,EOV.version_num, EOV.working_mode,
		    EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
	INTO	namev, status, ver_num, work_mode,
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
			EOV.refid = _refid AND EOV.eb_objects_id = EO.id
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
			
RETURN QUERY
	SELECT namev, status, ver_num,
	COALESCE(work_mode,false), workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal;
END

$BODY$;

ALTER FUNCTION public.eb_objects_update_dashboard(text)
    OWNER TO postgres;



-- FUNCTION: public.eb_update_rel(integer, text[])

-- DROP FUNCTION public.eb_update_rel(integer, text[]);

CREATE OR REPLACE FUNCTION public.eb_update_rel(
	commit_uidv integer,
	relationsv text[])
    RETURNS integer
    LANGUAGE 'plpgsql'
    
AS $BODY$

BEGIN
    UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by= commit_uidv , removed_at=NOW()
    WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = 'eb_roby_dev-eb_roby_dev-2-429-788'  )) 
        except 
            SELECT unnest(ARRAY['eb_roby_dev-eb_roby_dev-12-420-754']));

    INSERT INTO eb_objects_relations 
        (dominant, dependant, removed_by, removed_at) 
    SELECT 
        dominant, dependant, commit_uidv, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        except 
        SELECT unnest(array(select dominant from eb_objects_relations WHERE dependant = 'eb_roby_dev-eb_roby_dev-2-429-788'  ))));
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_update_rel(integer, text[])
    OWNER TO postgres;




-- FUNCTION: public.eb_authenticate_unified(text, text, text, text)

-- DROP FUNCTION public.eb_authenticate_unified(text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_unified(
	uname text DEFAULT NULL::text,
	password text DEFAULT NULL::text,
	social text DEFAULT NULL::text,
	wc text DEFAULT NULL::text)
    RETURNS TABLE(userid integer, email text, firstname text, roles_a text, rolename_a text, permissions text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE firstname TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;

BEGIN
	-- NORMAL
	IF uname IS NOT NULL AND password IS NOT NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.firstname
        FROM eb_users WHERE eb_users.email = uname AND pwd = password INTO userid, email, firstname;
    END IF;
    -- SSO
    IF uname IS NOT NULL AND password IS NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.firstname
        FROM eb_users WHERE eb_users.email = uname INTO userid, email, firstname;
    END IF;
    -- SOCIAL
    IF uname IS NULL AND password IS NULL AND social IS NOT NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.firstname
        FROM eb_users WHERE eb_users.socialid = social INTO userid, email, firstname;
    END IF;

	IF userid > 0 THEN
        SELECT roles, rolename FROM eb_getroles(userid, wc) INTO roles_a, rolename_a;

        SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;

        RETURN QUERY SELECT userid, email, firstname, roles_a, rolename_a, permissions;
   	END IF;
END;

$BODY$;

ALTER FUNCTION public.eb_authenticate_unified(text, text, text, text)
    OWNER TO postgres;





-- FUNCTION: public.eb_getroles(integer, text)

-- DROP FUNCTION public.eb_getroles(integer, text);

CREATE OR REPLACE FUNCTION public.eb_getroles(
	userid integer,
	wc text)
    RETURNS TABLE(roles text, rolename text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	DECLARE app_type integer[];
BEGIN
	
    IF wc = 'tc' OR wc = 'dc' THEN
    app_type:='{1, 2, 3}';
    END IF;
    IF wc = 'uc' THEN
    app_type:='{1}';
    END IF;
	IF wc = 'mc' THEN
    app_type:='{2}';
    END IF;
    IF wc = 'bc' THEN
    app_type:='{3}';
    END IF;
    
	RETURN QUERY  
    SELECT 
    	array_to_string(array_agg(id), ','), 
        array_to_string(array_agg(role_name), ',') FROM 
    (SELECT 
    	id, role_name FROM eb_roles WHERE id>=100 AND
    applicationid = ANY(SELECT id FROM eb_applications WHERE application_type=ANY(app_type)) AND
    id = ANY(
    SELECT role_id FROM eb_role2user WHERE user_id=userid
	UNION ALL
	(WITH RECURSIVE role2role AS 
	(
    	SELECT 
        	role2_id AS role_id
    	FROM 
        	eb_role2role
    	WHERE 
        	role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id=userid)
    	UNION ALL
    	SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id
	) SELECT * FROM role2role)
	ORDER BY 
		role_id)
    UNION
    SELECT role_id as id, CAST('SysRole' as text) as role_name FROM eb_role2user  
    where user_id=userid AND role_id<100 AND eb_del='F') as ROLES;

END;

$BODY$;

ALTER FUNCTION public.eb_getroles(integer, text)
    OWNER TO postgres;




-- FUNCTION: public.eb_authenticate_anonymous(text, text, text, text, integer, text)

-- DROP FUNCTION public.eb_authenticate_anonymous(text, text, text, text, integer, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_anonymous(
	_socialid text DEFAULT NULL::text,
	_fullname text DEFAULT NULL::text,
	_emailid text DEFAULT NULL::text,
	_phone text DEFAULT NULL::text,
	_appid integer DEFAULT NULL::integer,
	_wc text DEFAULT NULL::text)
    RETURNS TABLE(_userid integer, _email text, _firstname text, _roles_a text, _rolename_a text, _permissions text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE _userid INTEGER;
DECLARE _email TEXT;
DECLARE _firstname TEXT;
DECLARE _roles_a TEXT;
DECLARE _rolename_a TEXT;
DECLARE _permissions TEXT;
DECLARE _is_anon_auth_req BOOL;

BEGIN

_is_anon_auth_req := false;

IF _socialid IS NOT NULL THEN

    SELECT userid, email, fullname, roles_a, rolename_a, permissions 
    FROM eb_authenticate_unified(social => _socialid, wc => _wc) 
    INTO _userid, _email, _firstname, _roles_a, _rolename_a, _permissions;
    
    IF _userid IS NULL THEN
    
		SELECT A.id, A.email, A.name FROM eb_usersanonymous A WHERE A.socialid = _socialid AND appid = _appid
        INTO _userid, _email, _firstname;
            
		IF _userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (socialid, fullname, firstvisit, lastvisit, appid) VALUES (_socialid, _fullname, NOW(), NOW(), _appid);
		ELSE
			UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE id = _userid;
		END IF;
       
        _is_anon_auth_req := TRUE;
        
    END IF;

ELSE

	IF _emailid IS NOT NULL OR _phone IS NOT NULL THEN
    
    	SELECT A.id, A.email, A.name FROM eb_usersanonymous A 
        WHERE (A.email = _emailid OR A.phoneno = _phone) AND appid = _appid INTO _userid, _email, _firstname;
        
        IF _userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid) VALUES (_emailid, _phone, _fullname, NOW(), NOW(), _appid);
        ELSE
        	IF _email IS NULL THEN
            	UPDATE eb_usersanonymous SET email = _emailid, lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE phoneno = _phone;
            ELSE
            	UPDATE eb_usersanonymous SET phoneno = _phone, lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE email = _emailid;
            END IF;
        END IF;
        
        _is_anon_auth_req := TRUE;
        
    END IF;
    
END IF;

IF _is_anon_auth_req THEN
	SELECT userid, email, fullname, roles_a, rolename_a, permissions 
    FROM eb_authenticate_unified(uname => 'anonymous@anonym.com', password => '294de3557d9d00b3d2d8a1e6aab028cf', wc => _wc) 
    INTO _userid, _email, _firstname, _roles_a, _rolename_a, _permissions;
END IF;

RETURN QUERY
    SELECT _userid, _email, _firstname, _roles_a, _rolename_a, _permissions;

END;

$BODY$;

ALTER FUNCTION public.eb_authenticate_anonymous(text, text, text, text, integer, text)
    OWNER TO postgres;





