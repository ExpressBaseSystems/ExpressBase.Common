-- FUNCTION: public.eb_botdetails(integer)

-- DROP FUNCTION public.eb_botdetails(integer);

CREATE OR REPLACE FUNCTION public.eb_botdetails(
	solutionid integer)
    RETURNS TABLE(botname text, returnurl text, returnbotid text, createdby text, createdat timestamp without time zone, modifiedby text, modifiedat timestamp without time zone, returnwelcome text) 
    LANGUAGE 'plpgsql'

   
AS $BODY$

  
BEGIN
    RETURN QUERY
	SELECT 
		name, 
		url, 
		botid, 
		(SELECT firstname FROM eb_users WHERE id = eb_bots.created_by) AS created_by, 
		created_at, 
		(SELECT firstname FROM eb_users WHERE id = eb_bots.modified_by) AS modified_by, 
		modified_at,welcome_msg 
	FROM 
		eb_bots 
	WHERE 
		solution_id = solutionid;

END;

$BODY$;

ALTER FUNCTION public.eb_botdetails(integer)
    OWNER TO postgres;

