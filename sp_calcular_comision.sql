DROP PROCEDURE IF EXISTS sp_calcular_comision$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_calcular_comision()
BEGIN
	/*Variables generales del proceso*/
	declare vNivelMaximo       INT; 
	declare vNivelActual       INT;
	declare vPadre             INT;
	declare vMontoInsertar     Float;
	declare vDone              INT;
	declare vMontoPendiente    float;
	declare vDiasPaso          Int;
  declare vPagado            int;

	/*Variables para el cursor*/
	declare 	vcIdtMovimiento 						          Int; 
	declare		vcTTipoMovimiento_idtTipoMovimiento 	INT; 
	declare		vcTTipoPago_idtTipoPago				        INT;
	declare		vcUsuarioMovimiento					          int; 
	declare		vcUsuarioAlta							            int;
  declare   vcMonto                               int;
	

	/*Cursor de los movimientos activos y no contados*/
	DECLARE 	cursorMovimiento 
	cursor for 	
	select 		mov.idtMovimiento,
    				mov.tTipoMovimiento_idtTipoMovimiento,
    				mov.tTipoPago_idtTipoPago,
    				mov.usuarioMovimiento,
    				mov.usuarioAlta,
            mov.Monto
	from 		  tMovimiento as mov
	where		  activado = 1
	and			  contado = 0
	and 		  mov.fechaMovimiento < now();
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET vDone = 1;
	
    /*Parámetros de configuración*/
	select valor into vDiasPaso from tParametro where idtParametro = 4; /*Días que se acumula*/
	
	/*Se pasan históricos y se limpian tablas de día*/
	call sp_limpiar_historicos_comisiones();

	/*Aquellos usuarios que están capacitados a recibir una comisión*/
	insert into tUsuarioComision(egbusiness_members_userid,Monto,FechaCalculoComision)
	select userid,0,now() from egbusiness_members where cuenta is not null and cuenta <> '' and userlevel = 1; 
	
	SET vDone = 0;
	
	/*En caso de inconsistencia para que no se cicle*/
	update egbusiness_members set parent = 0 where userid = parent;
  update egbusiness_members set parent = sponsor where sponsor <> parent;

	open cursorMovimiento;
  read_loop: LOOP

		/*Obtenemos datos del movimiento*/
		FETCH cursorMovimiento 
    INTO  vcIdtMovimiento,
					vcTTipoMovimiento_idtTipoMovimiento,
					vcTTipoPago_idtTipoPago,
					vcUsuarioMovimiento,
					vcUsuarioAlta,
          vcMonto;
		
		IF vDone THEN
		  LEAVE read_loop;
		END IF;
		
		set vNivelActual = 0;
		
    /*Validación para usuario en colocación*/
    IF vcUsuarioAlta = vcUsuarioMovimiento 
    then 
		
      select parent into vPadre from egbusiness_members where userid = vcUsuarioMovimiento;
    
    else /*Es colocación*/
			
      SET vPadre = vcUsuarioAlta;
		
    end if;
		
    /*Niveles para afiliacion*/
    if vcTTipoMovimiento_idtTipoMovimiento = 1 then /*Es afiliacion*/
    
      set vNivelMaximo = 1; 
    
    else
   
      set vNivelMaximo = 4;
  
    end if;
        
    set vPagado = 0;
    set vMontoInsertar = 0;

		/*Comienza proceso de comisiones*/
		while((vNivelActual < vNivelMaximo or vPagado = 0) and vPadre <> 0) 
		do
			
      if (vNivelActual < vNivelMaximo)
      then
  
  			if vcTTipoMovimiento_idtTipoMovimiento = 1 /*Es afiliacion*/
  			then
  				
          set vMontoInsertar = vMontoInsertar + (vcMonto * .308642);
  
  			else /*Es recompra*/
  					
          if(vNivelActual = 0)
          then
              set vMontoInsertar = vMontoInsertar + (vcMonto * .026);
          elseif (vNivelActual = 1)
          then
              set vMontoInsertar = vMontoInsertar + (vcMonto * .0777);
          elseif (vNivelActual = 2)
          then
              set vMontoInsertar = vMontoInsertar + (vcMonto * .26);
          else
              set vMontoInsertar = vMontoInsertar + (vcMonto * 0);
          end if;
  
  			end if;
  
      end if;
            
	    /*Validamos que el usuario esté activo*/
      if exists (select * from egbusiness_members where userid = vPadre and userlevel = 1)
      then
      
        /*Validamos que tenga cuenta*/
        if exists (select * from egbusiness_members where userid = vPadre and cuenta is not null and cuenta <> '')
        then /*Puede cobrar*/

            set vMontoPendiente = 0;
					  
            if exists (select * from tComisionPendiente where idUsuario = vPadre)
            then

              select monto into vMontoPendiente from tComisionPendiente where idUsuario = vPadre;

            else

              set vMontoPendiente = 0;

            end if;
						
            update 	tUsuarioComision 
	          set 	  monto = monto + vMontoInsertar + vMontoPendiente
				  	where 	egbusiness_members_userid = vPadre;

          	insert into tComisionMovimiento(idComision,idMovimiento,fecha,monto) 
					  select 	idcomision, vcIdtMovimiento, now() , (vMontoInsertar + vMontoPendiente)
					  from   	tUsuarioComision 
					  where 	egbusiness_members_userid = vPadre;
						
            insert into tHComisionPendiente(idUsuario,monto,fechaUltimaAct,idComision,fechaHist)
						select  idUsuario,monto,fechaUltimaAct,idComision,now()
						from    tComisionPendiente where idUsuario = vPadre;
						
            delete from tComisionPendiente where idUsuario = vPadre;

            set vMontoInsertar = 0;
            set vPagado = 1;
				
        else
            
            /*Validar si se le acumula*/
            IF EXISTS(  select  * 
                        from    egbusiness_members a 
                        where   timestampdiff(DAY,from_unixtime(`a`.`joindate`),curdate()) < vDiasPaso 
                        and     userid = vPadre
                      )/*Tiene x días, se le guarda*/
            THEN /*Se le acumula*/
               
                IF EXISTS (select * from tComisionPendiente where idUsuario = vPadre) 
                then
  							  update tComisionPendiente set monto = monto + vMontoInsertar, fechaUltimaAct = now() where idUsuario = vPadre;
								else
							    insert into tComisionPendiente(idUsuario,monto,fechaUltimaAct) values (vPadre,vMontoInsertar,now());
								end if;

                insert into tComisionPendienteMovimiento (idMovimiento,idComision) select vcIdtMovimiento, idComision from tComisionPendiente where idUsuario = vPadre;
                set vMontoInsertar = 0;
                set vPagado = 1;

            else

              set vPagado = 0;

					  end if;
                  
          end if;
          
      else

        set vPagado = 0;

      end if;

      set vNivelActual = vNivelActual + 1;
      
      select parent into vPadre from egbusiness_members where userid = vPadre;

    end while;
    
    update tMovimiento a set a.contado = 1 where a.idtMovimiento = vcIdtMovimiento;
    /*Bono de la fundación*/
    if(vMontoInsertar > 0)
    then
      update tParametro
      set valor = valor + vMontoInsertar
      where idtParametro = 2;
    end if;
  
  end LOOP;
  CLOSE cursorMovimiento;

	update 	tUsuarioComision com
	join	tComisionPendiente pen
	on		com.egbusiness_members_userid = pen.idUsuario
	join	egbusiness_members mem on pen.idUsuario = mem.userid
	set		com.Monto = pen.monto
	where	com.egbusiness_members_userid is not null
	and		mem.userlevel = 1
	and		mem.cuenta is not null
	and		mem.cuenta <> '';
  
  insert into tHComisionPendiente(idUsuario,monto,fechaUltimaAct,idComision,fechaHist)
	select 	pen.idUsuario,pen.monto,pen.fechaUltimaAct,pen.idComision,now()
	from 	tComisionPendiente pen
	join 	egbusiness_members mem on pen.idUsuario = mem.userid
	where	mem.userlevel = 1
	and		mem.cuenta is not null
	and		mem.cuenta <> ''
	and 	pen.idUsuario is not null;
	
	delete from tComisionPendiente 
	where idUsuario in (select 	userid
						from  egbusiness_members mem
						where	mem.userlevel = 1
						and		mem.cuenta is not null
						and		mem.cuenta <> '');
						
  
END
$$