DROP PROCEDURE IF EXISTS sp_consultaMovimientosComision$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaMovimientosComision(pidComision int)
begin
SELECT
  mov.idtMovimiento,
  usr.loginid,
  CONCAT(usr.name_l, ' ', usr.name_f) AS usuario,
  `tipo`.`Descripcion` AS tipoMovimiento,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  date (`mov`.`FechaMovimiento`) AS FechaMovimiento,
  `mov`.`Referencia`,
  CONCAT('$', FORMAT(comMov.monto, 2)) AS montoMovimiento
FROM tComisionMovimiento comMov,
     tMovimiento mov,
     egbusiness_members usr,
     tTipoMovimiento AS tipo
WHERE mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
AND mov.usuarioMovimiento = usr.userid
AND comMov.idMovimiento = mov.idtMovimiento
AND idComision = pidComision
ORDER BY 6 DESC;
END
$$