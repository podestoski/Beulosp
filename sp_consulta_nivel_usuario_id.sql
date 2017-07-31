DROP PROCEDURE IF EXISTS sp_consulta_nivel_usuario_id$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_nivel_usuario_id(idUsuario int)
BEGIN
SELECT
  UPPER(esq.`id`) AS 'idUsuario'
FROM com_esquema esq
  JOIN egbusiness_members mem
    ON esq.id = mem.nivel
WHERE mem.userid = idUsuario;
END
$$