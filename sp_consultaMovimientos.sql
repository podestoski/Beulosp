DROP PROCEDURE IF EXISTS sp_consultaMovimientos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaMovimientos()
begin
SELECT DISTINCT
  mov.idtMovimiento,
  date (`mov`.`FechaMovimiento`) AS FechaMovimiento,
  mov.usuarioMovimiento,
  usr.loginid,
  CONCAT(usr.name_l, ' ', usr.name_f) AS usuario,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  `tipo`.`Descripcion` AS tipoMovimiento,
  `mov`.`Referencia`,
  CASE mov.tBanco_idtBanco WHEN 0 THEN CONCAT('Otro: ', mov.otroBanco) ELSE `banco`.`Descripcion` END AS banco,
  esq.descripcion AS Nivel,
  CASE mem2.loginid WHEN usr.loginid THEN "" ELSE mem2.loginid END AS usuarioColocacion,
  mov.Activado,
  mov.contado,
  CASE WHEN rel.idMovimiento IS NOT NULL THEN 1 ELSE 0 END AS fraccionado
FROM tMovimiento mov
  JOIN egbusiness_members AS usr
    ON mov.contado = 0
    AND mov.usuarioMovimiento = usr.userid
  JOIN tTipoMovimiento AS tipo
    ON mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
  JOIN tBanco AS banco
    ON mov.tBanco_idtBanco = banco.idtBanco
  JOIN tTipoPago AS pago
    ON mov.tTipoPago_idtTipoPago = pago.idtTipoPago
  JOIN tPaquete AS prod
    ON mov.tProducto_idtProducto = prod.idtPaquete
  JOIN egbusiness_members AS mem2
    ON mov.usuarioAlta = mem2.userid
  JOIN com_esquema AS esq
    ON mov.nivel = esq.id
  LEFT JOIN com_rel_fraccionadoMovimiento AS rel
    ON rel.idMovimiento = mov.idtMovimiento
ORDER BY 2 DESC;
END
$$