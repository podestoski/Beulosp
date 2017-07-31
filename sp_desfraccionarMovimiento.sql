DROP PROCEDURE IF EXISTS sp_desfraccionarMovimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_desfraccionarMovimiento(pIdMovimiento int)
begin
DELETE
  FROM tMovimiento
WHERE idtMovimiento = pIdMovimiento;

INSERT INTO com_movimientosFraccionados (referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario)
  SELECT
    a.referencia,
    a.fechaMovimiento,
    a.fechaCaptura,
    a.idBanco,
    a.monto,
    a.descripcion,
    a.idUsuario
  FROM com_hMovimientosFraccionados a
    JOIN com_rel_fraccionadoMovimiento b
      ON a.idH = b.idfraccionado
      AND b.idMovimiento = pIdMovimiento;

DELETE
  FROM com_hMovimientosFraccionados
WHERE idH IN (SELECT
      idfraccionado
    FROM com_rel_fraccionadoMovimiento
    WHERE idMovimiento = pIdMovimiento);

DELETE
  FROM com_rel_fraccionadoMovimiento
WHERE idMovimiento = pIdMovimiento;

DELETE
  FROM temp_usrActivadoPorFraccionado
WHERE idMovimiento = pIdMovimiento;

DELETE
  FROM com_movimientosFraccionados
WHERE id IN (SELECT
      idFraccionado
    FROM com_rel_excendenteMovimiento
    WHERE idMovimiento = pIdMovimiento);

DELETE
  FROM com_rel_excendenteMovimiento
WHERE idMovimiento = pIdMovimiento;

END
$$