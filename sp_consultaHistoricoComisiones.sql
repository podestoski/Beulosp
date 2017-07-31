DROP PROCEDURE IF EXISTS sp_consultaHistoricoComisiones$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaHistoricoComisiones(pFecha date)
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
     tHUsuarioComision com
WHERE usr.userid = com.egbusiness_members_userid
AND date (com.FechaCalculoComision) = pFecha
ORDER BY nombre ASC;
END
$$