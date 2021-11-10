-- FUNCTION: public.eb_create_or_update_role2loc(integer, integer, integer[])

-- DROP FUNCTION public.eb_create_or_update_role2loc(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role2loc(
	_roleid integer,
	_userid integer,
	_locations integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

BEGIN

UPDATE eb_role2location SET eb_del = 'T', eb_revokedat = NOW(), eb_revokedby = _userid 
	WHERE roleid = _roleid AND eb_del = 'F' AND locationid IN(SELECT UNNEST(ARRAY(SELECT locationid FROM eb_role2location WHERE roleid = _roleid AND eb_del = 'F')) 
        EXCEPT SELECT UNNEST(ARRAY[_locations]));

INSERT INTO eb_role2location(locationid, roleid, eb_createdby, eb_createdat) 
    SELECT _locs, _roleid, _userid, NOW() FROM UNNEST(ARRAY(SELECT UNNEST(ARRAY[_locations])
        EXCEPT SELECT UNNEST(ARRAY(SELECT locationid FROM eb_role2location WHERE roleid = _roleid AND eb_del = 'F')))) AS _locs;

RETURN 0;
END;

$BODY$;


