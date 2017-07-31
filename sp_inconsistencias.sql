CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE youngel3_sg.sp_inconsistencias()
BEGIN
	
	if exists (select * from egbusiness_members 
	where 	userid = parent 
	or 		userid = sponsor 
	or 		parent = null 
	or		sponsor = null
	or		(userlevel = 1 and nivel = null))
	then
		select 0 as resultado;
	else
		select 1 as resultado;
end if;

end