
DROP PROCEDURE IF EXISTS sp_consultaTotalFraccionadosPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaTotalFraccionadosPorUsuario(pIdUsuario int)
begin
SELECT
  CONCAT('$', FORMAT(SUM(monto), 2)) AS total
FROM com_movimientosFraccionados mov
WHERE mov.idUsuario = pIdUsuario;
END
$$