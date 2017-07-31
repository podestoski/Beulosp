DROP PROCEDURE IF EXISTS sp_consultaTodosMovimientos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaTodosMovimientos(pLoginId varchar(100))
begin
	declare vId int;
SELECT
  userid INTO vId
FROM egbusiness_members
WHERE loginId = pLoginId;
SELECT
  mov.idtMovimiento,
  date (`mov`.`FechaMovimiento`) AS FechaMovimiento,
  mov.usuarioMovimiento,
  usr.loginid,
  CONCAT(usr.name_l, ' ', usr.name_f) AS usuario,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  `tipo`.`Descripcion` AS tipoMovimiento,
  `mov`.`Referencia`,
  `banco`.`Descripcion` AS banco,
  esq.descripcion AS Nivel,
  mov.usuarioAlta,
  mov.Activado,
  mov.contado
FROM tMovimiento mov,
     egbusiness_members usr,
     tTipoMovimiento AS tipo,
     tBanco AS banco,
     tTipoPago AS pago,
     tPaquete AS prod,
     com_esquema AS esq
WHERE mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
AND mov.tBanco_idtBanco = banco.idtBanco
AND mov.tTipoPago_idtTipoPago = pago.idtTipoPago
AND mov.tProducto_idtProducto = prod.idtPaquete
AND mov.usuarioMovimiento = usr.userid
AND contado = 1
AND usr.loginid = pLoginId
AND esq.id = mov.nivel
ORDER BY 2 DESC, 3;
END
$$