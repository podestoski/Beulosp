DROP PROCEDURE IF EXISTS sp_consultaMovimientosComisionPendienteHistorico$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaMovimientosComisionPendienteHistorico(pidComision int)
begin
SELECT
  mov.idtMovimiento,
  usr.loginid,
  CONCAT(usr.name_l, ' ', usr.name_f) AS usuario,
  `tipo`.`Descripcion` AS tipoMovimiento,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  date (`mov`.`FechaMovimiento`) AS FechaMovimiento,
  `mov`.`Referencia`,
  th.monto
FROM tHComisionMovimiento th
  JOIN tMovimiento mov
    ON th.idMovimiento = mov.idtMovimiento
  JOIN egbusiness_members usr
    ON usr.userid = mov.usuarioMovimiento
  JOIN tTipoMovimiento tipo
    ON tipo.idtTipoMovimiento = mov.tTipoMovimiento_idtTipoMovimiento
WHERE th.idComision = pidComision;
END
$$