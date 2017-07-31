DROP PROCEDURE IF EXISTS sp_consultaFechaHistoricaBonoFundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFechaHistoricaBonoFundacion()
begin
SELECT DISTINCT
  date (a.fechaPaso) AS Fecha
FROM tHBonoFundacion a;
END
$$