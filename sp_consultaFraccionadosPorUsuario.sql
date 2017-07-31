DROP PROCEDURE IF EXISTS sp_consultaFraccionadosPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFraccionadosPorUsuario(pIdUsuario int)
begin
SELECT
  mov.id,
  mov.referencia,
  mov.fechaMovimiento,
  mov.fechaCaptura,
  CASE mov.idBanco WHEN 0 THEN mov.otroBanco ELSE ban.Descripcion END AS Descripcion,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  DATE_ADD(fechaCaptura, INTERVAL 30 DAY) AS fechaVencimiento
FROM com_movimientosFraccionados mov
  JOIN tBanco ban
    ON mov.idBanco = ban.idtBanco
WHERE mov.idUsuario = pIdUsuario;
END
$$