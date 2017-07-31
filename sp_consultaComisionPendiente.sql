DROP PROCEDURE IF EXISTS sp_consultaComisionPendiente$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaComisionPendiente()
begin
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  CONCAT('$', FORMAT(pen.monto, 2)) AS monto,
  pen.fechaUltimaAct,
  pen.idComision
FROM egbusiness_members usr,
     tComisionPendiente pen
WHERE usr.userid = pen.idUsuario;
END
$$