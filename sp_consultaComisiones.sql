DROP PROCEDURE IF EXISTS sp_consultaComisiones$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaComisiones()
begin

SELECT
  usr.userid,
  usr.loginid AS USUARIO,
  CONCAT(usr.name_l, ' ', usr.name_f) AS NOMBRE,
  usr.banco AS BANCO,
  usr.cuenta AS CLABE,
  CONCAT('$', FORMAT(com.Monto, 2)) AS MONTO,
  date (com.FechaCalculoComision) AS FechaCalculoComision,
  com.idComision
FROM egbusiness_members usr,
     tUsuarioComision com
WHERE usr.userid = com.egbusiness_members_userid
AND usr.cuenta IS NOT NULL
AND usr.cuenta <> ''
AND com.Monto > 0
ORDER BY nombre ASC;

END
$$