DROP PROCEDURE IF EXISTS sp_consulta_tPaquete$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_tPaquete()
BEGIN
SELECT
  idtPaquete,
  Descripcion
FROM tPaquete;
END
$$