DROP PROCEDURE IF EXISTS sp_validar_tMovimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_validar_tMovimiento(movimiento INT)
BEGIN
UPDATE `tMovimiento`
SET `Activado` = 1
WHERE `idtMovimiento` = movimiento;
END
$$