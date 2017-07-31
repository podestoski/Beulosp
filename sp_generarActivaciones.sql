DROP PROCEDURE IF EXISTS sp_generarActivaciones;
CREATE PROCEDURE youngel3_sg.sp_generarActivaciones()
begin

    update egbusiness_members
  	set   userlevel = 1,
    			activedate = UNIX_TIMESTAMP(now()),
    			expdate = UNIX_TIMESTAMP(DATE_ADD(now(), interval 30 day)),
    			repay = 0
  	where userid in(
        
      select  usr.userid
      from    egbusiness_members usr
      JOIN    com_acumuladoUsuario acum on  timestampdiff(DAY,date(from_unixtime(`usr`.expdate)),curdate()) >= 0 
                                        and usr.userid = acum.idUsuario
      join    tParametro b on b.idtParametro = 7 and acum.monto >= b.Valor
    );


    insert into com_rel_acumuladoActivacion(idAcumulado,idUsuario,fechaCreacion,fechaActualizacion)
      select  acum.id,usr.userid,now(),now()
      from    egbusiness_members usr
      JOIN    com_acumuladoUsuario acum on  timestampdiff(DAY,date(from_unixtime(`usr`.expdate)),curdate()) >= 0 
                                        and usr.userlevel = 1 
                                        and usr.userid = acum.idUsuario
      join    tParametro b on b.idtParametro = 7 and acum.monto >= b.Valor; 


    insert into comh_acumuladoUsuario(id,idUsuario,fechaCreacion,fechaActualizacion,monto,fechaHistorica,motivo)
      select acum.id,acum.idUsuario,acum.fechaCreacion,acum.fechaActualizacion,acum.monto,now(),'Pasaron 30 días'
      from    egbusiness_members usr
      JOIN    com_acumuladoUsuario acum on  timestampdiff(DAY,date(from_unixtime(`usr`.expdate)),curdate()) >= 0 
                                        and usr.userid = acum.idUsuario;
  
  delete from com_acumuladoUsuario where id in
    (
      select  acum.id
      from    egbusiness_members usr
      JOIN    com_acumuladoUsuario acum on  timestampdiff(DAY,date(from_unixtime(`usr`.expdate)),curdate()) >= 0 
                                        and usr.userid = acum.idUsuario
    );

  end