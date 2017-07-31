DROP PROCEDURE IF EXISTS sp_guardarMovimientoFraccionado$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_guardarMovimientoFraccionado(pIdUsuario int,pReferencia varchar(255),pFecha datetime, pIdBanco int, pMonto float, pDescripcion varchar(3000), pOtroBanco varchar(255))
begin
INSERT INTO com_movimientosFraccionados (referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario, otroBanco)
  VALUES (pReferencia, pFecha, NOW(), pIdBanco, pMonto, pDescripcion, pIdUsuario, pOtroBanco);
END
$$