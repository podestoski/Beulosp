DROP PROCEDURE IF EXISTS sp_calcularIncentivo$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_calcularIncentivo(pIdUsuario int, pIdRango int)
begin
	declare vidIncentivo int;
	if exists( SELECT
    *
  FROM com_incentivos
  WHERE idRango = pIdRango) /*Se alcanzó un rango que genera un incentivo*/
THEN
SELECT
  id INTO vidIncentivo
FROM com_incentivos
WHERE idRango = pIdRango;
		if not exists( SELECT
    *
  FROM com_usuarioIncentivo
  WHERE idUsuario = pIdUsuario
  AND idIncentivo = vidIncentivo) THEN
INSERT INTO com_usuarioIncentivo (idIncentivo, idUsuario, Fecha)
  VALUES (vidIncentivo, pidUsuario, NOW());
END IF;
END IF;
    if (dayofyear(curdate()) = 90)
    then
UPDATE tParametro
SET Valor = 1
WHERE idtParametro = 6;
ELSE
		if (dayofyear(curdate()) = 180)
		then
UPDATE tParametro
SET Valor = 2
WHERE idtParametro = 6;
ELSE
			if (dayofyear(curdate()) = 270)
			then
UPDATE tParametro
SET Valor = 3
WHERE idtParametro = 6;
ELSE
				if (dayofyear(curdate()) = 360)
				then
UPDATE tParametro
SET Valor = 4
WHERE idtParametro = 6;
END IF;
END IF;
END IF;
END IF;
END
$$