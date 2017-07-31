DROP PROCEDURE IF EXISTS sp_pasoHistoricoMovimientoFraccionado$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_pasoHistoricoMovimientoFraccionado(pIdMovimiento int,pDescripcion varchar(3000))
begin

DELETE
  FROM com_hMovimientosFraccionados
WHERE TIMESTAMPDIFF(DAY, fechaHistorica, CURDATE()) > 365;

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
    pDescripcion
  FROM com_movimientosFraccionados
  WHERE id = pIdMovimiento;

DELETE
  FROM com_movimientosFraccionados
WHERE id = pIdMovimiento;
END
$$