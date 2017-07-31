DROP PROCEDURE IF EXISTS sp_consulta_nivel$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_nivel()
BEGIN
SELECT
  id,
  UPPER(`descripcion`) AS 'Nivel'
FROM com_esquema;
END
$$