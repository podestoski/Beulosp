CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE youngel3_sg.sp_borrar_movimiento(pCveMov int)
begin
	delete from tMovimiento
	where idtMovimiento = pCveMov;
end