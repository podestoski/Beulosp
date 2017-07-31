DROP PROCEDURE IF EXISTS sp_muestraIncentivo$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_muestraIncentivo()
begin
	declare vPeriodo int;
SELECT
  valor INTO vPeriodo
FROM tParametro
WHERE idtParametro = 6;
	if(vPeriodo = 0)
    then
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  inc.incentivo AS Incentivo,
  uin.Fecha
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE inc.id >= 5
ORDER BY 1;
END IF;
    if(vPeriodo = 1)
    then
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  inc.incentivo AS Incentivo,
  uin.Fecha
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE (inc.id = 1
AND DAYOFYEAR(uin.Fecha) BETWEEN 0 AND 90)
OR inc.id >= 5
ORDER BY 1;
END IF;
    if (vPeriodo = 2)
    then
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  inc.incentivo AS Incentivo,
  uin.Fecha
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE (inc.id = 1
AND DAYOFYEAR(uin.Fecha) BETWEEN 90 AND 180)
OR (inc.id = 2
AND DAYOFYEAR(uin.Fecha) BETWEEN 0 AND 180)
OR inc.id >= 5
ORDER BY 1;
END IF;
    if (vPeriodo = 3)
    then
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  inc.incentivo AS Incentivo,
  uin.Fecha
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE (inc.id = 1
AND DAYOFYEAR(uin.Fecha) BETWEEN 180 AND 270)
OR (inc.id = 3
AND DAYOFYEAR(uin.Fecha) BETWEEN 0 AND 270)
OR inc.id >= 5
ORDER BY 1;
END IF;
    if (vPeriodo = 4)
    then
SELECT
  CONCAT(usr.name_l, ' ', usr.name_f) AS Nombre,
  usr.loginid,
  inc.incentivo AS Incentivo,
  uin.Fecha
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE (inc.id = 1
AND DAYOFYEAR(uin.Fecha) BETWEEN 270 AND 360)
OR (inc.id = 2
AND DAYOFYEAR(uin.Fecha) BETWEEN 180 AND 360)
OR (inc.id = 4
AND DAYOFYEAR(uin.Fecha) BETWEEN 0 AND 360)
OR inc.id >= 5
ORDER BY 1;
END IF;
END
$$