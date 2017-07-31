DROP PROCEDURE IF EXISTS sp_pasarComisionPendiente_BonoFundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_pasarComisionPendiente_BonoFundacion(pidComisionPend INT)
begin
	declare monto float;
SELECT
  a.monto INTO monto
FROM tComisionPendiente a
WHERE a.idComision = pidComisionPend;
UPDATE tParametro
SET Valor = Valor + monto
WHERE idtParametro = 2;

DELETE
  FROM tHComisionPendienteMovimiento
WHERE TIMESTAMPDIFF(DAY, FechaHist, NOW() > 365);
INSERT INTO tHComisionPendienteMovimiento (idMovimiento, idComision, FechaHist)
  SELECT
    a.idMovimiento,
    a.idComision,
    NOW()
  FROM tComisionPendienteMovimiento a
  WHERE a.idComision = pidComisionPend;

DELETE
  FROM tHComisionPendiente
WHERE TIMESTAMPDIFF(DAY, FechaHist, NOW() > 365);
INSERT INTO tHComisionPendiente (idUsuario, monto, fechaUltimaAct, idComision, fechaHist)
  SELECT
    idUsuario,
    monto,
    fechaUltimaAct,
    idComision,
    NOW()
  FROM tComisionPendiente
  WHERE idComision = pidComisionPend;

INSERT INTO tComisionPendiente_BonoFundacion
  VALUES (pidComisionPend);

DELETE
  FROM tComisionPendiente
WHERE idComision = pidComisionPend;
END
$$