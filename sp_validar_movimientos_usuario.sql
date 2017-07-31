DROP PROCEDURE IF EXISTS sp_validar_movimientos_usuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_validar_movimientos_usuario(	idUsuario INT)
begin
UPDATE tMovimiento
SET Activado = 1
WHERE usuarioMovimiento = idUsuario;
END
$$