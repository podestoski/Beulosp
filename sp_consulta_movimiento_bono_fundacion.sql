DROP PROCEDURE IF EXISTS sp_consulta_movimiento_bono_fundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_movimiento_bono_fundacion()
begin
SELECT
  fun.razon,
  CONCAT(usr.name_l, ' ', usr.name_f) AS nombre,
  usr.loginId,
  `mov`.`idtMovimiento`,
  `tipo`.`Descripcion` AS tipoMovimiento,
  `mov`.`Referencia`,
  `mov`.`FechaMovimiento`,
  `pago`.`Descripcion` AS tipoPago,
  `banco`.`Descripcion` AS banco,
  `prod`.`Descripcion` AS Paquete
FROM tMovimiento AS mov,
     tMovimientoBonoPresidente AS fun,
     tTipoMovimiento AS tipo,
     tBanco AS banco,
     tTipoPago AS pago,
     tPaquete AS prod,
     egbusiness_members AS usr
WHERE usr.userid = fun.idUsuario
AND mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
AND mov.tBanco_idtBanco = banco.idtBanco
AND mov.tTipoPago_idtTipoPago = pago.idtTipoPago
AND mov.tProducto_idtProducto = prod.idtPaquete
AND mov.idtMovimiento = fun.idMovimiento;
END
$$