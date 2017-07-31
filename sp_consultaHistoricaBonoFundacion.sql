DROP PROCEDURE IF EXISTS sp_consultaHistoricaBonoFundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaHistoricaBonoFundacion(pFecha date)
begin
SELECT
  id,
  CONCAT('$', FORMAT(monto, 2))
FROM tHBonoFundacion a
WHERE date (fechaPaso) = pFecha;
END
$$