-- FUNCTION: public.eb_subscription_persist(text, text, text, integer, text, text)

-- DROP FUNCTION public.eb_subscription_persist(text, text, text, integer, text, text);

CREATE OR REPLACE FUNCTION public.eb_subscription_persist(
	sname text,
	i_sid text,
	e_sid text,
	tenant_id integer,
	descript text,
	js text)
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE    
    i record;
    eid integer;
BEGIN
insert into eb_solutions(solution_name,isolution_id,esolution_id,tenant_id,date_created,description)
values(sname,i_sid,e_sid,tenant_id,now(),descript) returning id into eid;
  if eid > 0 then
  	FOR i IN SELECT * FROM jsonb_each_text(js::jsonb)
  	LOOP
  	INSERT INTO solution_to_productplans(plan_id,product_id,solution_id) 
    values(i.value::integer,i.key::integer,eid);
  	END LOOP;
  end if;
  RETURN eid;
 END;

$BODY$;

ALTER FUNCTION public.eb_subscription_persist(text, text, text, integer, text, text)
    OWNER TO postgres;

