DROP PROCEDURE IF EXISTS sp_consulta_nivel_usuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_nivel_usuario(idUsuario int)
BEGIN
SELECT
  UPPER(ran.`descripcion`) AS 'Nivel'
FROM COM_RANGO ran
  JOIN egbusiness_members mem
    ON ran.IDRANGO = mem.nivel
WHERE mem.userid = idUsuario;
END
$$