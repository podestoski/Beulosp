
DROP PROCEDURE IF EXISTS sp_consultaMovimientos_Comision_Pendiente$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaMovimientos_Comision_Pendiente(pidComisionPend INT)
begin
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS usuario,
  usr.loginid,
  `mov`.`idtMovimiento`,
  `tipo`.`Descripcion` AS tipoMovimiento,
  `mov`.`Referencia`,
  date (`mov`.`FechaMovimiento`) AS FechaMovimiento,
  `pago`.`Descripcion` AS tipoPago,
  `banco`.`Descripcion` AS banco,
  esq.descripcion AS Nivel
FROM tComisionPendienteMovimiento bn,
     tMovimiento mov,
     egbusiness_members usr,
     tTipoMovimiento AS tipo,
     tBanco AS banco,
     tTipoPago AS pago,
     tPaquete AS prod,
     tComisionPendiente AS compen,
     com_esquema AS esq
WHERE mov.idtMovimiento = bn.idMovimiento
AND mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
AND mov.tBanco_idtBanco = banco.idtBanco
AND mov.tTipoPago_idtTipoPago = pago.idtTipoPago
AND mov.tProducto_idtProducto = prod.idtPaquete
AND compen.idComision = bn.idComision
AND mov.usuarioMovimiento = usr.userid
AND compen.idComision = pidComisionPend
AND esq.id = mov.nivel;
END
$$