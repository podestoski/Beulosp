DROP PROCEDURE IF EXISTS sp_insertar_nivel_usuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_insertar_nivel_usuario(idUsuario int, vnivel int)
BEGIN
UPDATE egbusiness_members
SET nivel = vnivel
WHERE userid = idUsuario;
END
$$