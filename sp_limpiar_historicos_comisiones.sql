DROP PROCEDURE IF EXISTS sp_limpiar_historicos_comisiones;
delimiter $$
CREATE 
PROCEDURE sp_limpiar_historicos_comisiones()
begin
	delete from tHComisionMovimiento where timestampdiff(DAY,fechaHist,curdate()) > 365;
	insert into tHComisionMovimiento(idComision,idMovimiento,fecha,fechaHist,monto)
	select idComision,idMovimiento,fecha,now(),monto
	from tComisionMovimiento;
	delete from tComisionMovimiento;

	delete from tHUsuarioComision where timestampdiff(DAY,FechaHist,curdate()) > 365;
	insert into tHUsuarioComision(idComision,egbusiness_members_userid,Monto,FechaCalculoComision,FechaHist)
	select idComision,egbusiness_members_userid,Monto,FechaCalculoComision, now()
	from tUsuarioComision;
	delete from tUsuarioComision;

	delete from tMovimiento where timestampdiff(DAY,FechaMovimiento,curdate()) > 365;
	
    delete from comh_acumulado_comision where timestampdiff(DAY,fechahistorica,curdate()) > 365;
    insert into comh_acumulado_comision(idh,idusuario,monto,contado,fecha,FechaHistorica)
    select id,idUsuario,monto,contado,fecha,now() from com_acumulado_comision;
    delete from com_acumulado_comision;
    
    delete from egbusiness_members_bcomisiones where timestampdiff(DAY,fecHistorica,curdate()) > 365;
	INSERT INTO `egbusiness_members_bcomisiones`
	(`userid`,`sponsor`,`parent`,`loginid`,`password`,`wd_acc`,`wd_name`,`wd_to`,`email`,`name_f`,`name_l`,`gender`,`address`,`city`,`zip`,`state`,`country`,
	`phone`,`im`,`batch`,`bday`,`joindate`,`activedate`,`expdate`,`userlevel`,`lastip`,`last_login`,`rotation`,`stats`,`sas`,`lang`,`entries`,`repay`,`point`,
	`sentmsgs`,`lastsent`,`balance`,`payout`,`setting`,`photo`,`cuenta`,`titular`,`banco`,`beneficiario`,`curp`,`rfc`,`referencia`,`reclutador`,`fecHistorica`,nivel)
	SELECT `userid`,`sponsor`,`parent`,`loginid`,`password`,`wd_acc`,`wd_name`,`wd_to`,`email`,`name_f`,`name_l`,`gender`,`address`,`city`,`zip`,`state`,`country`,
	`phone`,`im`,`batch`,`bday`,`joindate`,`activedate`,`expdate`,`userlevel`,`lastip`,`last_login`,`rotation`,`stats`,`sas`,`lang`,`entries`,`repay`,`point`,
	`sentmsgs`,`lastsent`,`balance`,`payout`,`setting`,`photo`,`cuenta`,`titular`,`banco`,`beneficiario`,`curp`,`rfc`,`referencia`,`reclutador`,CURDATE(),nivel
	FROM `egbusiness_members`;
	
end
$$