DROP PROCEDURE IF EXISTS sp_desactivar_fraccionados$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_desactivar_fraccionados()
BEGIN
/*Se limpia histórico*/
DELETE
  FROM com_hMovimientosFraccionados
WHERE TIMESTAMPDIFF(DAY, fechaHistorica, CURDATE()) > 365;

/*Se borran aquellos que tienen más de 30 días de vigencia*/
INSERT INTO com_hMovimientosFraccionados (idH, referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario, fechaHistorica, motivo)
  SELECT
    id,
    referencia,
    fechaMovimiento,
    fechaCaptura,
    idBanco,
    monto,
    descripcion,
    idUsuario,
    NOW(),
    '30 días de Vigencia'
  FROM com_movimientosFraccionados
  WHERE TIMESTAMPDIFF(DAY, fechaCaptura, CURDATE()) > 30;

DELETE
  FROM com_movimientosFraccionados
WHERE TIMESTAMPDIFF(DAY, fechaCaptura, CURDATE()) > 30;

/*Se borran aquellos en los que el usuario está inactivo*/
INSERT INTO com_hMovimientosFraccionados (idH, referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario, fechaHistorica, motivo)
  SELECT
    id,
    frac.referencia,
    fechaMovimiento,
    fechaCaptura,
    idBanco,
    monto,
    descripcion,
    idUsuario,
    NOW(),
    'Usuario Inactivo'
  FROM com_movimientosFraccionados frac
    JOIN egbusiness_members mem
      ON frac.idUsuario = mem.userid
      AND mem.userlevel = 0;

DELETE
  FROM com_movimientosFraccionados
WHERE idUsuario IN (SELECT
      userid
    FROM egbusiness_members
    WHERE userlevel = 0);

/*Se borran aquellos en los que el usuario capturó un movimiento distinto a Titanio*/
INSERT INTO com_hMovimientosFraccionados (idH, referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario, fechaHistorica, motivo)
  SELECT
    id,
    frac.referencia,
    frac.fechaMovimiento,
    frac.fechaCaptura,
    frac.idBanco,
    frac.monto,
    frac.descripcion,
    frac.idUsuario,
    NOW(),
    'Capturó movimiento distinto a titanio'
  FROM com_movimientosFraccionados frac
    JOIN tMovimiento mov
      ON frac.idUsuario = mov.usuarioMovimiento
      AND mov.Contado = 0
      AND mov.Nivel <> 1
      AND date (mov.FechaCaptura) = CURDATE();

DELETE
  FROM com_movimientosFraccionados
WHERE idUsuario IN (SELECT
      usuarioMovimiento
    FROM tMovimiento
    WHERE Contado = 0
    AND Nivel <> 1
    AND date (FechaMovimiento) = CURDATE());

END
$$