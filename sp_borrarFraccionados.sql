CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE youngel3_sg.sp_borrarFraccionado(pIdMovimiento int)
begin
	call sp_pasoHistoricoMovimientoFraccionado(pIdMovimiento,'Borrado manualmente');
end