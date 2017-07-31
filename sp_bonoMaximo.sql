DROP PROCEDURE IF EXISTS sp_bonoMaximo$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_bonoMaximo()
BEGIN

DELETE
  FROM egbusiness_members_bbonos
WHERE TIMESTAMPDIFF(DAY, fecHistorica, CURDATE()) > 365;

INSERT INTO `egbusiness_members_bbonos` (`userid`, `sponsor`, `parent`, `loginid`, `password`, `wd_acc`, `wd_name`, `wd_to`, `email`, `name_f`, `name_l`, `gender`, `address`, `city`, `zip`, `state`, `country`,
`phone`, `im`, `batch`, `bday`, `joindate`, `activedate`, `expdate`, `userlevel`, `lastip`, `last_login`, `rotation`, `stats`, `sas`, `lang`, `entries`, `repay`, `point`,
`sentmsgs`, `lastsent`, `balance`, `payout`, `setting`, `photo`, `cuenta`, `titular`, `banco`, `beneficiario`, `curp`, `rfc`, `referencia`, `reclutador`, `regalos`, `fecHistorica`)
  SELECT
    `userid`,
    `sponsor`,
    `parent`,
    `loginid`,
    `password`,
    `wd_acc`,
    `wd_name`,
    `wd_to`,
    `email`,
    `name_f`,
    `name_l`,
    `gender`,
    `address`,
    `city`,
    `zip`,
    `state`,
    `country`,
    `phone`,
    `im`,
    `batch`,
    `bday`,
    `joindate`,
    `activedate`,
    `expdate`,
    `userlevel`,
    `lastip`,
    `last_login`,
    `rotation`,
    `stats`,
    `sas`,
    `lang`,
    `entries`,
    `repay`,
    `point`,
    `sentmsgs`,
    `lastsent`,
    `balance`,
    `payout`,
    `setting`,
    `photo`,
    `cuenta`,
    `titular`,
    `banco`,
    `beneficiario`,
    `curp`,
    `rfc`,
    `referencia`,
    `reclutador`,
    `regalos`,
    CURDATE()
  FROM `egbusiness_members`;


DELETE
  FROM tHBonos
WHERE TIMESTAMPDIFF(DAY, FechaHist, CURDATE()) > 365;

INSERT INTO tHBonos (egbusiness_members_userid, `Fecha de Calculo`, `Usuarios Activos`, `tRangoBonos_idtRangoBonos`, `FechaHist`, FechaMaxima)
  SELECT
    egbusiness_members_userid,
    `Fecha de Calculo`,
    `Usuarios Activos`,
    `tRangoBonos_idtRangoBonos`,
    CURDATE(),
    FechaMaxima
  FROM tBonos;

DELETE
  FROM tBonos;

INSERT INTO tBonos (egbusiness_members_userid, `Fecha de Calculo`, `Usuarios Activos`, `tRangoBonos_idtRangoBonos`, FechaMaxima)

DROP PROCEDURE IF EXISTS sp_borrarFraccionado$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_borrarFraccionado(pIdMovimiento int)
begin
CALL sp_pasoHistoricoMovimientoFraccionado(pIdMovimiento, 'Borrado manualmente');
END
$$

DROP PROCEDURE IF EXISTS sp_borrar_movimiento$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_borrar_movimiento(pCveMov int)
begin
DELETE
  FROM tMovimiento
WHERE idtMovimiento = pCveMov;
END
$$

DROP PROCEDURE IF EXISTS sp_borra_recorre$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_borra_recorre()
BEGIN
	
	declare userIdCursor Int;
 
	declare parentCursor Int;
	declare done Int;
	
	
    declare nuevoPadre Int;
	declare contar Int;

	declare diasInactividad Int;
	
	
	DECLARE 	cursorUsuarios 
	cursor for
SELECT
  a.userId
FROM egbusiness_members AS a,
     tParametro b
WHERE ((TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`a`.`expdate`), CURDATE()) > b.Valor)
AND (`a`.`userlevel` = 0)
AND a.userId <> 0
AND b.idtParametro = 3)
AND TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`a`.`expdate`), CURDATE()) < 16433;


DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;


SELECT
  valor INTO diasInactividad
FROM tParametro
WHERE idtParametro = 3;


INSERT INTO `egbusiness_members_copy` (`userid`, `sponsor`, `parent`, `loginid`, `password`, `wd_acc`, `wd_name`, `wd_to`, `email`, `name_f`, `name_l`, `gender`, `address`, `city`, `zip`, `state`, `country`,
`phone`, `im`, `batch`, `bday`, `joindate`, `activedate`, `expdate`, `userlevel`, `lastip`, `last_login`, `rotation`, `stats`, `sas`, `lang`, `entries`, `repay`, `point`,
`sentmsgs`, `lastsent`, `balance`, `payout`, `setting`, `photo`, `cuenta`, `titular`, `banco`, `beneficiario`, `curp`, `rfc`, `referencia`, `reclutador`, `regalos`, `fecHistorica`)
  SELECT
    `userid`,
    `sponsor`,
    `parent`,
    `loginid`,
    `password`,
    `wd_acc`,
    `wd_name`,
    `wd_to`,
    `email`,
    `name_f`,
    `name_l`,
    `gender`,
    `address`,
    `city`,
    `zip`,
    `state`,
    `country`,
    `phone`,
    `im`,
    `batch`,
    `bday`,
    `joindate`,
    `activedate`,
    `expdate`,
    `userlevel`,
    `lastip`,
    `last_login`,
    `rotation`,
    `stats`,
    `sas`,
    `lang`,
    `entries`,
    `repay`,
    `point`,
    `sentmsgs`,
    `lastsent`,
    `balance`,
    `payout`,
    `setting`,
    `photo`,
    `cuenta`,
    `titular`,
    `banco`,
    `beneficiario`,
    `curp`,
    `rfc`,
    `referencia`,
    `reclutador`,
    `regalos`,
    CURDATE()
  FROM `egbusiness_members`;
	
	set done = 0;
	
	
	open cursorUsuarios;
		read_loop: LOOP
		
		set done = 0;
		FETCH cursorUsuarios INTO userIdCursor;
		
		IF done THEN
		  LEAVE read_loop;
		END IF;

SELECT
  sponsor INTO parentCursor
FROM egbusiness_members
WHERE userid = userIdCursor;

		IF parentCursor = userIdCursor then
			set parentCursor = 0;
		end if;

		IF parentCursor = 0 then
UPDATE egbusiness_members bm
SET bm.parent = parentCursor,
    bm.sponsor = parentCursor
WHERE bm.sponsor = userIdCursor;

INSERT INTO controlBorraRecorre (userid, parent, fecha, diasInactivos)
  SELECT
    userIdCursor,
    parentCursor,
    CURDATE(),
    TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`bm`.`expdate`), CURDATE())
  FROM egbusiness_members bm
  WHERE bm.userid = userIdCursor;
ELSE

SELECT
  COUNT(bm.userId) INTO contar
FROM egbusiness_members bm
WHERE bm.userId = parentCursor
AND ((TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`bm`.`expdate`), CURDATE()) > diasInactividad)
AND (`bm`.`userlevel` = 0));
			
			set nuevoPadre = parentCursor;
			
			while contar > 0 do

SELECT
  sponsor INTO nuevoPadre
FROM egbusiness_members bm
WHERE bm.userid = nuevoPadre;

SELECT
  COUNT(bm.userId) INTO contar
FROM egbusiness_members bm
WHERE bm.userId = nuevoPadre
AND ((TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`bm`.`expdate`), CURDATE()) > diasInactividad)
AND (`bm`.`userlevel` = 0));
				
				IF nuevoPadre = 0 then
					set contar = 0;
				end if;
				
			end while;

UPDATE egbusiness_members bm
SET bm.parent = nuevoPadre,
    bm.sponsor = nuevoPadre
WHERE bm.sponsor = userIdCursor;

INSERT INTO controlBorraRecorre (userid, parent, fecha, diasInactivos)
  SELECT
    userIdCursor,
    parentCursor,
    CURDATE(),
    TIMESTAMPDIFF(DAY, FROM_UNIXTIME(`bm`.`expdate`), CURDATE())
  FROM egbusiness_members bm
  WHERE bm.userid = userIdCursor;

END IF;


/*delete from egbusiness_members
where userId = userIdCursor;
set done = 0;*/

END LOOP;
	
	CLOSE cursorUsuarios;

end
$$