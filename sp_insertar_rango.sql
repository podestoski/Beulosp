DROP PROCEDURE IF EXISTS sp_insertar_rango$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_insertar_rango(IN pUsuario int, IN pActivos int)
BEGIN
	declare vRangoActual int;
    declare vRangoNuevo int;
SELECT
  IDRANGO INTO vRangoNuevo
FROM COM_RANGO
WHERE pActivos BETWEEN rango_menor AND rango_mayor;
    if exists( SELECT
    *
  FROM COM_ACTIVOS_RANGO
  WHERE IDUSUARIO = pUsuario) THEN
SELECT
  IDRANGO INTO vRangoActual
FROM COM_ACTIVOS_RANGO
WHERE IDUSUARIO = pUsuario;
        if vRangoNuevo > vRangoActual
        then
DELETE
  FROM COM_ACTIVOS_RANGO
WHERE IDUSUARIO = pUsuario;
INSERT INTO COM_ACTIVOS_RANGO (idusuario, activos, fecha, idrango)
  VALUES (pUsuario, pActivos, NOW(), vRangoNuevo);
            set vRangoActual = vRangoNuevo;
        end if;
    else
INSERT INTO COM_ACTIVOS_RANGO (idusuario, activos, fecha, idrango)
  VALUES (pUsuario, pActivos, NOW(), vRangoNuevo);
        set vRangoActual = vRangoNuevo;
	end if;
CALL sp_calcularIncentivo(pUsuario, vRangoActual);
    if exists ( SELECT
    *
  FROM egbusiness_members
  WHERE userid = pUsuario
  AND (nivel IS NULL
  OR nivel = 1
  OR nivel = 0)) /*Solo para aquellos que no tienen*/
THEN
UPDATE egbusiness_members
SET nivel = vRangoActual
WHERE userid = pUsuario;
END IF;
	if (dayofmonth(curdate()) = 25)
    then
DELETE
  FROM HCOM_ACTIVOS_RANGO
WHERE TIMESTAMPDIFF(DAY, FechaH, CURDATE()) > 365;

INSERT INTO HCOM_ACTIVOS_RANGO (IDH, ACTIVOS, FECHA, IDRANGO, FECHAH)
  SELECT
    IDUSUARIO,
    ACTIVOS,
    FECHA,
    IDRANGO,
    NOW()
  FROM COM_ACTIVOS_RANGO
  WHERE IDUSUARIO = pUsuario;

UPDATE egbusiness_members
SET nivel = vRangoActual
WHERE userid = pUsuario;

DELETE
  FROM COM_ACTIVOS_RANGO
WHERE IDUSUARIO = pUsuario;
END IF;

END
$$