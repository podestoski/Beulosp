
DROP PROCEDURE IF EXISTS sp_insertarDesactivacionMediaRecompra$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_insertarDesactivacionMediaRecompra(puserid int, pFechaRegistro datetime, pBool int)
begin
	if pBool = 1
	then
		if not exists( SELECT
    *
  FROM tDesactivacion
  WHERE userid = puserid) THEN
INSERT INTO tDesactivacion (userid, fechaRegistro)
  VALUES (puserid, pFechaRegistro);
END IF;
ELSE
		if exists ( SELECT
    *
  FROM tDesactivacion
  WHERE userid = puserid) THEN
DELETE
  FROM tDesactivacion
WHERE userid = puserid;
END IF;
END IF;
END
$$