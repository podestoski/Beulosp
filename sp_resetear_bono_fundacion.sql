DROP PROCEDURE IF EXISTS sp_resetear_bono_fundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_resetear_bono_fundacion()
begin
DELETE
  FROM tHBonoFundacion
WHERE TIMESTAMPDIFF(DAY, fechaPaso, CURDATE()) > 365;
INSERT INTO tHBonoFundacion (monto, fechaPaso)
  SELECT
    Valor,
    NOW()
  FROM tParametro
  WHERE idtParametro = 2;

DELETE
  FROM tHMovimientoBonoPresidente
WHERE TIMESTAMPDIFF(DAY, FechaHist, CURDATE()) > 365;
INSERT INTO tHMovimientoBonoPresidente (idMovimiento, idUsuario, razon, fechaHist)
  SELECT
    idMovimiento,
    idUsuario,
    razon,
    NOW()
  FROM tMovimientoBonoPresidente;
DELETE
  FROM tMovimientoBonoPresidente;

DELETE
  FROM tHComisionPendiente_BonoFundacion
WHERE TIMESTAMPDIFF(DAY, FechaHist, CURDATE()) > 365;
INSERT INTO tHComisionPendiente_BonoFundacion (idComisionPend, FechaHist)
  SELECT
    idComisionPend,
    NOW()
  FROM tComisionPendiente_BonoFundacion;
DELETE
  FROM tComisionPendiente_BonoFundacion;

UPDATE tParametro
SET Valor = 0
WHERE idtParametro = 2;

END
$$