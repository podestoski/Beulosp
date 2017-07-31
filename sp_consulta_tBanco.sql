DROP PROCEDURE IF EXISTS sp_consulta_tBanco$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_tBanco()
BEGIN
SELECT
  idtBanco,
  Descripcion
FROM tBanco
WHERE idtBanco <> 0
ORDER BY 2;
END
$$