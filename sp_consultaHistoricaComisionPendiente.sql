DROP PROCEDURE IF EXISTS sp_consultaHistoricaComisionPendiente$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaHistoricaComisionPendiente(pFecha date)
begin
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  CONCAT('$', FORMAT(pen.monto, 2)) AS monto,
  pen.fechaUltimaAct,
  pen.idComision
FROM egbusiness_members usr,
     tHComisionPendiente pen
WHERE usr.userid = pen.idUsuario
AND date (pen.fechaHist) = pFecha;
END
$$