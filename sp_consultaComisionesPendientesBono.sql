DROP PROCEDURE IF EXISTS sp_consultaComisionesPendientesBono$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaComisionesPendientesBono()
begin
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  CONCAT('$', FORMAT(pen.monto, 2)) AS monto,
  pen.fechaUltimaAct,
  pen.idComision
FROM egbusiness_members usr,
     tHComisionPendiente pen,
     tComisionPendiente_BonoFundacion tbon
WHERE usr.userid = pen.idUsuario
AND tbon.idComisionPend = pen.idComision
ORDER BY 1 ASC;
END
$$