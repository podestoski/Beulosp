DROP PROCEDURE IF EXISTS sp_insertar_tMovimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_insertar_tMovimiento(	
	 in pIdTipoMovimiento INT, 
	 in pReferencia VARCHAR(255),
	 in pFechaMovimiento datetime,
	 in pIdTipoPago INT,
	 in pIdBanco	INT,
	 in pIdProducto INT,
	 in pActivado BOOL,
	 in pUsuarioMovimiento INT,
	 in pOtroBanco VARCHAR(255),
	 in pUsuarioAlta INT,
	 in pComentario VARCHAR(10000),
	 in pMonto float,
	 in pNivel int,
     out pIdOut int
)
BEGIN

	declare vIdMovimientoNuevo int;
    declare vIdAcumulado int;
  	declare vEstatusUsuario int;

SELECT
  userlevel INTO vEstatusUsuario
FROM egbusiness_members
WHERE userid = pUsuarioMovimiento;

INSERT INTO tMovimiento (tTipoMovimiento_idtTipoMovimiento,
Referencia,
FechaMovimiento,
tTipoPago_idtTipoPago,
tBanco_idtBanco,
tProducto_idtProducto,
Activado,
Contado,
usuarioMovimiento,
otroBanco,
usuarioAlta,
comentario,
monto,
nivel,
FechaCaptura)
  VALUES (pIdTipoMovimiento, pReferencia, pFechaMovimiento, pIdTipoPago, pIdBanco, pIdProducto, pActivado, FALSE, pUsuarioMovimiento, pOtroBanco, pUsuarioAlta, pComentario, pMonto, pNivel, NOW());

SELECT
  MAX(idtMovimiento) INTO vIdMovimientoNuevo
FROM tMovimiento;
						
  	if(pActivado = 1)/*El movimiento viene desde el admin. Si viene desde la oficina virtual entonces solo se inserta*/
  	then
  		
  		if(vEstatusUsuario = 0)/*Si el usuario está inactivo*/
  		then
UPDATE egbusiness_members
SET userlevel = 1,
    activedate = UNIX_TIMESTAMP(NOW()),
    expdate = UNIX_TIMESTAMP(DATE_ADD(NOW(), INTERVAL 30 DAY)),
    repay = 0
WHERE userid = pUsuarioMovimiento;

INSERT INTO com_rel_activacionMovimiento (idUsuario, idMovimiento, fecha)
  VALUES (pUsuarioMovimiento, vIdMovimientoNuevo, NOW());

ELSE/*El usuario está activo, se le debe acumular la cantidad*/
  	
			if exists ( SELECT
    *
  FROM com_acumuladoUsuario
  WHERE idUsuario = pUsuarioMovimiento) THEN
UPDATE com_acumuladoUsuario
SET monto = monto + pMonto,
    fechaActualizacion = NOW()
WHERE idUsuario = pUsuarioMovimiento;
ELSE
INSERT INTO com_acumuladoUsuario (idUsuario, monto, fechaCreacion)
  VALUES (pUsuarioMovimiento, pMonto, NOW());
END IF;

SELECT
  id INTO vIdAcumulado
FROM com_acumuladoUsuario
WHERE idUsuario = pUsuarioMovimiento;

INSERT INTO com_rel_movimiento_acumulado (idMovimiento, idAcumulado, monto, fecha)
  VALUES (vIdMovimientoNuevo, vIdAcumulado, pMonto, NOW());

END IF;

END IF;

SELECT
  MAX(idtMovimiento) INTO pIdOut
FROM tMovimiento;

SELECT
  vIdMovimientoNuevo;

END
$$