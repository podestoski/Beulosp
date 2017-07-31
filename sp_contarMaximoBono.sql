DROP PROCEDURE IF EXISTS sp_contarMaximoBono$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_contarMaximoBono(IN pUsuario int, IN pActivos int)
BEGIN
	declare vValorMaximo int;
	if exists( SELECT
    *
  FROM tMaximoBonos
  WHERE idUsuario = pUsuario) THEN
SELECT
  maximoUsuarios INTO vValorMaximo
FROM tMaximoBonos
WHERE idUsuario = pUsuario;
        if pActivos > vValorMaximo
        then
DELETE
  FROM tMaximoBonos
WHERE idUsuario = pUsuario;
INSERT INTO tMaximoBonos (idUsuario, FechaModificacion, maximoUsuarios, idtRangoBonos)
  SELECT
    pUsuario,
    CURDATE(),
    pActivos,
    idtRangoBonos
  FROM tRangoBonos
  WHERE pActivos BETWEEN limiteInferior AND limitesuperior;
END IF;
ELSE
INSERT INTO tMaximoBonos (idUsuario, FechaModificacion, maximoUsuarios, idtRangoBonos)
  SELECT
    pUsuario,
    CURDATE(),
    pActivos,
    idtRangoBonos
  FROM tRangoBonos
  WHERE pActivos BETWEEN limiteInferior AND limitesuperior;
END IF;
END
$$