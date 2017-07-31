CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE youngel3_sg.sp_consulta_movimientos_ultima_comision(idUsuario int)
begin
	SELECT `mov`.`idtMovimiento`,
    `mov`.`tTipoMovimiento_idtTipoMovimiento`,
	`tipo`.`Descripcion` as tipoMovimiento,
    `mov`.`Referencia`,
    `mov`.`FechaMovimiento`,
    `mov`.`tTipoPago_idtTipoPago`,
	`pago`.`Descripcion` as tipoPago,
    `mov`.`tBanco_idtBanco`,
	`banco`.`Descripcion` as banco,
    `mov`.`tProducto_idtProducto`,
	 esq.descripcion as Nivel,
    `mov`.`Activado`,
    `mov`.`Contado`,
    `mov`.`usuarioMovimiento`,
    `mov`.`otroBanco`,
    `mov`.`usuarioAlta`,
	concat(usr.name_l,' ',usr.name_f) as nombre,
	if(movCom.monto	is null, '0',concat('$',format(movCom.monto,2))) as montoMovimiento
	FROM `tMovimiento` as mov,
	tTipoMovimiento  as tipo,
	tBanco 			 as banco,
	tTipoPago		 as pago,
	tPaquete		 as prod,
	tUsuarioComision as com,
	tComisionMovimiento as movCom,
	egbusiness_members as usr,
	com_esquema 	as esq
	where com.egbusiness_members_userid = idUsuario
	and	  mov.tTipoMovimiento_idtTipoMovimiento = tipo.idtTipoMovimiento
	and   mov.tBanco_idtBanco = banco.idtBanco
	and	  mov.tTipoPago_idtTipoPago = pago.idtTipoPago
	and	  mov.tProducto_idtProducto = prod.idtPaquete
	and	  movCom.idMovimiento = mov.idtMovimiento
	and   movCom.idComision = com.idComision
	and   usr.userid = mov.usuarioMovimiento
	and   esq.id = mov.nivel;
end