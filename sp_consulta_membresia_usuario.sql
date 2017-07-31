DROP PROCEDURE IF EXISTS sp_consulta_membresia_usuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_membresia_usuario(pidUsuario int)
BEGIN
SELECT
  esq.descripcion
FROM com_esquema esq
  JOIN (SELECT
      *
    FROM tMovimiento
    WHERE usuarioMovimiento = pidUsuario
    AND FechaMovimiento > '2016-02-18'
    ORDER BY FechaMovimiento DESC LIMIT 1) mov
    ON esq.id = mov.nivel;
END
$$