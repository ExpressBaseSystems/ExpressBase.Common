CREATE DEFINER=`josevin`@`%` FUNCTION `eb_objects_commit`(idv text,
    obj_namev text,
    obj_descv text,
    obj_typev integer,
    obj_jsonv json,
    obj_changelogv text,
    commit_uidv integer,
    relationsstring text,
    tagsv text,
    appsstring text,
    disp_name text) RETURNS text CHARSET latin1
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE committed_refidunique text;
DECLARE major integer;
DECLARE minor integer;
DECLARE patch integer;
DECLARE version_number text;
-- DECLARE relationsv text[];
-- DECLARE apps integer[];

CREATE TEMPORARY table relationsv(id int auto_increment, value text);
insert into relationsv(value) values(relationsstring);

CREATE TEMPORARY TABLE apps(id int auto_increment, value text);
insert into apps(value) values(convert(appsstring,unsigned));

UPDATE eb_objects 
	SET 
    	obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv, display_name = disp_name
	WHERE 
    	id = objid; 
        
UPDATE eb_objects_ver
	SET
    	obj_json = obj_jsonv, obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = NOW()
	WHERE
    	-- eb_objects_id= objid AND major_ver_num=major AND working_mode='T' 
		refid = idv;
select last_insert_id() INTO inserted_obj_ver_id;

-- refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
    set committed_refidunique=idv;
	-- UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  
    
-- majorversion.minorversion.patchversion
	set version_number = CONCAT_WS('.', major, minor, patch);
   UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = idv;
   
-- relations table
   
CREATE TEMPORARY TABLE temp_dom
	SELECT dominant from eb_objects_relations WHERE dependant = idv
		AND dominant NOT IN (SELECT value FROM relationsv);
        
UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(
             select `value` from temp_dom);
             
INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, idv 
      FROM (SELECT  value from relationsv where value not in
      	(SELECT  dominant from eb_objects_relations WHERE dependant = idv)) as dominantvals;
    
-- application table    

CREATE TEMPORARY TABLE temp_appid
		SELECT appid from eb_objects2application WHERE obj_id = objid AND eb_del='F'
        AND appid NOT IN (SELECT value FROM apps);

UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
         select `value` from apps)
		AND obj_id = objid;
        
INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (select value from apps where value not in (select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')
        having min(id) )as appvals;
        
RETURN committed_refidunique;
END