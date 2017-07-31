DROP PROCEDURE IF EXISTS sp_consultaHistoricaComisionesPendientesBono$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaHistoricaComisionesPendientesBono(pFecha date)
begin
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  CONCAT('$', FORMAT(pen.monto, 2)) AS monto,
  pen.fechaUltimaAct,
  pen.idComision
FROM egbusiness_members usr,
     tHComisionPendiente pen,
     tHComisionPendiente_BonoFundacion tbon
WHERE usr.userid = pen.idUsuario
AND tbon.idComisionPend = pen.idComision
AND date (tbon.fechaHist) = pFecha
ORDER BY 1 ASC;
END
$$