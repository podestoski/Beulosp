DROP PROCEDURE IF EXISTS sp_consultaFechaHistoricaMovimientos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFechaHistoricaMovimientos()
begin
SELECT DISTINCT
  date (a.FechaMovimiento) AS Fecha
FROM tMovimiento a
WHERE Contado = 1;
END
$$