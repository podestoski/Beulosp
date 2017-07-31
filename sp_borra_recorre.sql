CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE youngel3_sg.sp_borra_recorre()
BEGIN
	
	declare userIdCursor Int; 
	declare parentCursor Int;
	declare done Int;
	
	
    declare nuevoPadre Int;
	declare contar Int;

	declare diasInactividad Int;
	
	
	DECLARE 	cursorUsuarios 
	cursor for 	
	select 		a.userId
    from		egbusiness_members as a,
				tParametro b
	where 		((timestampdiff(DAY,from_unixtime(`a`.`expdate`),curdate()) > b.Valor) and (`a`.`userlevel` = 0) and a.userId <> 0 and b.idtParametro = 3)
	and			timestampdiff(DAY,from_unixtime(`a`.`expdate`),curdate()) < 16433;
	
	
	DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
	
	
	select valor into diasInactividad from tParametro where idtParametro = 3;

	
	INSERT INTO `egbusiness_members_copy`
	(`userid`,`sponsor`,`parent`,`loginid`,`password`,`wd_acc`,`wd_name`,`wd_to`,`email`,`name_f`,`name_l`,`gender`,`address`,`city`,`zip`,`state`,`country`,
	`phone`,`im`,`batch`,`bday`,`joindate`,`activedate`,`expdate`,`userlevel`,`lastip`,`last_login`,`rotation`,`stats`,`sas`,`lang`,`entries`,`repay`,`point`,
	`sentmsgs`,`lastsent`,`balance`,`payout`,`setting`,`photo`,`cuenta`,`titular`,`banco`,`beneficiario`,`curp`,`rfc`,`referencia`,`reclutador`,`regalos`,`fecHistorica`)
	SELECT `userid`,`sponsor`,`parent`,`loginid`,`password`,`wd_acc`,`wd_name`,`wd_to`,`email`,`name_f`,`name_l`,`gender`,`address`,`city`,`zip`,`state`,`country`,
	`phone`,`im`,`batch`,`bday`,`joindate`,`activedate`,`expdate`,`userlevel`,`lastip`,`last_login`,`rotation`,`stats`,`sas`,`lang`,`entries`,`repay`,`point`,
	`sentmsgs`,`lastsent`,`balance`,`payout`,`setting`,`photo`,`cuenta`,`titular`,`banco`,`beneficiario`,`curp`,`rfc`,`referencia`,`reclutador`,`regalos`,CURDATE()
	FROM `egbusiness_members`;
	
	set done = 0;
	
	
	open cursorUsuarios;
		read_loop: LOOP
		
		set done = 0;
		FETCH cursorUsuarios INTO userIdCursor;
		
		IF done THEN
		  LEAVE read_loop;
		END IF;

		select sponsor into parentCursor from egbusiness_members where userid = userIdCursor;

		IF parentCursor = userIdCursor then
			set parentCursor = 0;
		end if;

		IF parentCursor = 0 then
			update egbusiness_members bm
			set bm.parent = parentCursor,
          bm.sponsor = parentCursor
			where bm.sponsor = userIdCursor;
			
			insert into controlBorraRecorre (userid,parent,fecha,diasInactivos)
			select userIdCursor,parentCursor,curdate(), timestampdiff(DAY,from_unixtime(`bm`.`expdate`),curdate()) from egbusiness_members bm where bm.userid = userIdCursor;
		ELSE
			
			select count(bm.userId) into contar
			from egbusiness_members bm
			where bm.userId = parentCursor
			and ((timestampdiff(DAY,from_unixtime(`bm`.`expdate`),curdate()) > diasInactividad) and (`bm`.`userlevel` = 0));
			
			set nuevoPadre = parentCursor;
			
			while contar > 0 do
				
				select sponsor into nuevoPadre
				from egbusiness_members bm
				where bm.userid = nuevoPadre;

				select count(bm.userId) into contar
				from egbusiness_members bm
				where bm.userId = nuevoPadre
				and ((timestampdiff(DAY,from_unixtime(`bm`.`expdate`),curdate()) > diasInactividad) and (`bm`.`userlevel` = 0));
				
				IF nuevoPadre = 0 then
					set contar = 0;
				end if;
				
			end while;
			
			update egbusiness_members bm
			set bm.parent = nuevoPadre,
          bm.sponsor = nuevoPadre
			where bm.sponsor = userIdCursor;

			insert into controlBorraRecorre (userid,parent,fecha,diasInactivos)
			select userIdCursor,parentCursor,curdate(), timestampdiff(DAY,from_unixtime(`bm`.`expdate`),curdate()) from egbusiness_members bm where bm.userid = userIdCursor;
			
		END IF;
		
		
		/*delete from egbusiness_members
		where userId = userIdCursor;
		set done = 0;*/
	
	END loop;
	
	CLOSE cursorUsuarios;

end