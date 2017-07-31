DROP PROCEDURE IF EXISTS sp_consultaComisionesPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaComisionesPorUsuario(IN pUsuario int)
begin

SELECT
  usr.userid,
  usr.name_f,
  usr.name_l,
  CONCAT('$', FORMAT(com.Monto, 2)),
  date (com.FechaCalculoComision) AS FechaCalculoComision
FROM egbusiness_members usr,
     tUsuarioComision com
WHERE usr.userid = com.egbusiness_members_userid
AND usr.userid = pUsuario;
END
$$