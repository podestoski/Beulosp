DROP PROCEDURE IF EXISTS sp_consultaFechaHistoricaBonos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFechaHistoricaBonos()
begin
SELECT DISTINCT
  date (a.`Fecha de Calculo`) AS Fecha
FROM tHBonos a;
END
$$