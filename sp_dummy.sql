DROP PROCEDURE IF EXISTS sp_dummy$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_dummy()
begin
SELECT
  `idtBanco`,
  `Descripcion`,
  `idtBanco`,
  `Descripcion`,
  `idtBanco`
FROM tBanco;
END
$$