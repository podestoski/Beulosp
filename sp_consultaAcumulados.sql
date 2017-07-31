DROP PROCEDURE IF EXISTS sp_consultaAcumulados$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaAcumulados()
begin

SELECT
  acum.id,
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  acum.monto
FROM com_acumuladoUsuario acum
  JOIN egbusiness_members usr
    ON acum.idUsuario = usr.userid
ORDER BY Nombre ASC;

END
$$