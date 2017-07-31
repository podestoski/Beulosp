DROP PROCEDURE IF EXISTS sp_activar_movimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_activar_movimiento(pCveMov int, activar int)
begin
	declare vMonto float;
  declare vIdUsuario int;
  declare vEstatusUsuario int;
  declare vMontoMovimiento float;
  declare vIdAcumulado int;

UPDATE tMovimiento
SET Activado = activar
WHERE idtMovimiento = pCveMov;

SELECT
  usuarioMovimiento INTO vIdUsuario
FROM tMovimiento
WHERE idtMovimiento = pCveMov;
SELECT
  userlevel INTO vEstatusUsuario
FROM egbusiness_members
WHERE userid = vIdUsuario;
SELECT
  Monto INTO vMontoMovimiento
FROM tMovimiento
WHERE idtMovimiento = pCveMov;

  if(activar = 0)
  then
    
    if exists( SELECT
    *
  FROM com_rel_activacionMovimiento
  WHERE idMovimiento = pCveMov) THEN

UPDATE egbusiness_members
SET userlevel = 0,
    repay = 5
WHERE userid IN (SELECT
    idUsuario
  FROM com_rel_activacionMovimiento
  WHERE idMovimiento = pCveMov);
DELETE
  FROM com_rel_activacionMovimiento
WHERE idMovimiento = pCveMov;


END IF;
  
    if exists( SELECT
    *
  FROM com_rel_movimiento_acumulado
  WHERE idMovimiento = pCveMov) THEN

SELECT
  monto INTO vMonto
FROM com_rel_movimiento_acumulado
WHERE idMovimiento = pCveMov;

UPDATE com_acumuladoUsuario
SET monto = monto - vMonto
WHERE idUsuario = vIdUsuario;

DELETE
  FROM com_rel_movimiento_acumulado
WHERE idMovimiento = pCveMov;

END IF;

ELSE

    if(vEstatusUsuario = 0)/*Si el usuario está inactivo*/
  		then

        if(vMontoMovimiento >= 1500)
        then
UPDATE egbusiness_members
SET userlevel = 1,
    activedate = UNIX_TIMESTAMP(NOW()),
    expdate = UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)),
    repay = 0
WHERE userid = vIdUsuario;

INSERT INTO com_rel_activacionMovimiento (idUsuario, idMovimiento, fecha)
  VALUES (vIdUsuario, pCveMov, NOW());
END IF;

ELSE/*El usuario está activo, se le debe acumular la cantidad*/
  	
			if exists ( SELECT
    *
  FROM com_acumuladoUsuario
  WHERE idUsuario = pUsuarioMovimiento) THEN
UPDATE com_acumuladoUsuario
SET monto = monto + vMontoMovimiento,
    fechaActualizacion = NOW()
WHERE idUsuario = vIdUsuario;
ELSE
INSERT INTO com_acumuladoUsuario (idUsuario, monto, fechaCreacion)
  VALUES (pCveMov, vMontoMovimiento, NOW());
END IF;

SELECT
  id INTO vIdAcumulado
FROM com_acumuladoUsuario
WHERE idUsuario = vIdUsuario;

INSERT INTO com_rel_movimiento_acumulado (idMovimiento, idAcumulado, monto, fecha)
  VALUES (pCveMov, vIdAcumulado, vMontoMovimiento, NOW());

END IF;


END IF;


END
$$