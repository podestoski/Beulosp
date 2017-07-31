DROP PROCEDURE IF EXISTS sp_consultaFechaHistoricaComisiones$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFechaHistoricaComisiones()
begin
SELECT DISTINCT
  date (FechaCalculoComision) AS Fecha
FROM tHUsuarioComision
ORDER BY Fecha DESC;
END
$$