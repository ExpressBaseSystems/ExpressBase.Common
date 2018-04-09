
CREATE OR REPLACE FUNCTION eb_get_tagged_object(
tag CLOB
)
RETURN TAG_TABLE
AS
    return_tbl TAG_TABLE;
    piped_tag CLOB;
BEGIN

    piped_tag := replace(tag,',','|'); --select replace('aa,bb,cc',',','|') from dual;

    SELECT 
	TAG_RECORD(EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status) BULK COLLECT
    INTO
    return_tbl
FROM 
	eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS
WHERE 
	EO.id =EOV.eb_objects_id
    AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17)
    AND EO.id IN(select id from eb_objects where REGEXP_LIKE (obj_tags , '(^|,)'||piped_tag||'(,|$)'));

    RETURN return_tbl;

END;