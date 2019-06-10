CREATE PROCEDURE eb_botdetails(IN solutionid INTEGER,
OUT botname TEXT, 
OUT returnurl TEXT, 
OUT returnbotid TEXT, 
OUT createdby TEXT, 
OUT createdat TIMESTAMP, 
OUT modifiedby TEXT, 
OUT modifiedat TIMESTAMP, 
OUT returnwelcome TEXT)
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
		solution_id = solutionid INTO botname,returnurl,returnbotid,createdby,
        createdat,modifiedby,modifiedat,returnwelcome;
END