DROP PROCEDURE IF EXISTS sp_consulta_tTipoPago$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_tTipoPago()
BEGIN
SELECT
  idtTipoPago,
  Descripcion
FROM tTipoPago;
END
$$