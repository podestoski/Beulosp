DROP PROCEDURE IF EXISTS sp_consulta_tTipoMovimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_tTipoMovimiento()
BEGIN
SELECT
  idtTipoMovimiento,
  `Descripcion`
FROM tTipoMovimiento
WHERE idtTipoMovimiento < 3;
END
$$