-- FUNCTION: public.eb_objects_create_major_version(text, integer, integer, text, text, text[])

-- DROP FUNCTION public.eb_objects_create_major_version(text, integer, integer, text, text, text[]);


CREATE OR REPLACE FUNCTION eb_object_create_major_version(
	idv varchar2,
	obj_typev NUMBER,
	commit_uidv NUMBER,
	src_pid CLOB,
	cur_pid CLOB,
	relationsv VARCHAR)
    RETURN CLOB 
    

AS refidunique VARCHAR(100); inserted_obj_ver_id NUMBER; objid NUMBER; committed_refidunique CLOB; major NUMBER; version_number CLOB;objjson CLOB;

BEGIN
    SELECT eb_objects_id,obj_json into objid,objjson FROM eb_objects_ver WHERE refid = idv;
    
	SELECT MAX(major_ver_num) into major from eb_objects_ver WHERE eb_objects_id = objid;
    
    version_number := CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(major+1,'.'),0),'.'),0),'.'),'w');
    
	INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json,commit_ts,commit_uid,version_num,working_mode,major_ver_num,minor_ver_num,patch_ver_num) values (objid,objjson,SYSTIMESTAMP,commit_uidv,version_number,'T',major+1,0,0) 
        RETURNING id INTO inserted_obj_ver_id;
	
    refidunique :=CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(src_pid,'-'),cur_pid),'-'),obj_typev),'-'),objid),'-'),inserted_obj_ver_id);
     committed_refidunique:=refidunique;
     
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;    
    
    INSERT INTO eb_objects_status(eb_obj_ver_id, status, userid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, SYSTIMESTAMP);
    
	UPDATE eb_objects_relations SET eb_del = 'T', removed_by= commit_uidv , removed_at=SYSTIMESTAMP
      WHERE 
        dominant IN(SELECT dominant FROM eb_objects_relations WHERE dependant = refidunique 
                    MINUS 
                    SELECT regexp_substr(relationsv,'[^,]+', 1, level)  AS dominantvals from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null);
          
    INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidunique 
      FROM (
      SELECT regexp_substr(relationsv,'[^,]+', 1, level)  AS dominantvals from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null
      MINUS
      select dominant from eb_objects_relations WHERE dependant = refidunique
      );
                         
    RETURN committed_refidunique; 	

END;
