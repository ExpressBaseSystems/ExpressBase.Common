-- FUNCTION: public.eb_create_solution(text, text, text, integer, text)

-- DROP FUNCTION public.eb_create_solution(text, text, text, integer, text);

CREATE OR REPLACE FUNCTION public.eb_create_solution(
	sname text,
	i_sid text,
	e_sid text,
	tenant_id_in integer,
	descript text)
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE    
    i record;
    eid integer;
BEGIN

INSERT INTO eb_solutions(solution_name,isolution_id,esolution_id,tenant_id,date_created,description, pricing_tier)
	VALUES(sname,i_sid,e_sid,tenant_id_in,now(),descript, 0) RETURNING id INTO eid;
	
INSERT INTO eb_role2tenant(tenant_id, solution_id, sys_role_id, eb_createdat, eb_createdby)
	VALUES(tenant_id_in, e_sid, 0, NOW(), tenant_id_in);
	
RETURN eid;
END;

$BODY$;

ALTER FUNCTION public.eb_create_solution(text, text, text, integer, text)
    OWNER TO postgres;


