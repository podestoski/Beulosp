DROP PROCEDURE IF EXISTS sp_consultaFechaHistoricaComisionesPendientes$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFechaHistoricaComisionesPendientes()
begin
SELECT DISTINCT
  date (fechaHist) AS Fecha
FROM tHComisionPendiente;
END
$$