-- FUNCTION AS PROCEDURE: eb_botdetails(integer)

-- DROP PROCEDURE IF EXISTS TESTPRO;

DELIMITER $$       
CREATE PROCEDURE eb_botdetails(IN solutionid integer)  
BEGIN
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
END$$