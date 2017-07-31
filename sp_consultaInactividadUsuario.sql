DROP PROCEDURE IF EXISTS sp_consultaInactividadUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaInactividadUsuario(pIdUsuario int)
begin
SELECT
  userlevel
FROM egbusiness_members
WHERE userid = pIdUsuario;
END
$$