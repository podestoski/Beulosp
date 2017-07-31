DROP PROCEDURE IF EXISTS sp_consultaMovimientosPendientesPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaMovimientosPendientesPorUsuario(pidUsuario int)
BEGIN
SELECT
  mov.idtMovimiento,
  mov.tTipoMovimiento_idtTipoMovimiento,
  tMov.`Descripcion`,
  mov.Referencia,
  mov.FechaMovimiento,
  mov.tTipoPago_idtTipoPago,
  pag.Descripcion,
  mov.tBanco_idtBanco,
  ban.Descripcion,
  mov.tProducto_idtProducto,
  paq.Descripcion,
  mov.Contado,
  mov.Activado,
  mov.usuarioMovimiento,
  mem.name_f,
  mem.name_l,
  mov.otroBanco,
  mov.usuarioAlta,
  mem2.name_f,
  mem2.name_l,
  CONCAT(mem2.name_f, ' ', mem2.name_l) AS Nombre
FROM tMovimiento mov
  JOIN tTipoMovimiento tMov
    ON mov.tTipoMovimiento_idtTipoMovimiento = tMov.idtTipoMovimiento
  JOIN tTipoPago pag
    ON mov.tTipoPago_idtTipoPago = pag.idtTipoPago
  JOIN tBanco ban
    ON mov.tBanco_idtBanco = ban.idtBanco
  JOIN tPaquete paq
    ON mov.tProducto_idtProducto = paq.idtPaquete
  JOIN egbusiness_members mem
    ON mov.usuarioMovimiento = mem.userid
  JOIN egbusiness_members mem2
    ON mov.usuarioAlta = mem2.userid
WHERE mov.usuarioMovimiento = pidUsuario
AND mov.Activado = 0;


END
$$