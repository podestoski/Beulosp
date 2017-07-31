DROP PROCEDURE IF EXISTS sp_consultaEstatusUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaEstatusUsuario(in pIdUsuario int)
begin

SELECT
  userlevel
FROM egbusiness_members
WHERE userid = pIdUsuario;

END
$$