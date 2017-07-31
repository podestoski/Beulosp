DROP PROCEDURE IF EXISTS sp_consultaBonos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaBonos()
begin
	declare vFecha date;
SELECT
  MAX(`Fecha de Calculo`) INTO vFecha
FROM tBonos;
SELECT
  usr.loginid AS userid,
  CONCAT(usr.name_l, ' ', usr.name_f) AS NOMBRE,
  usr.banco AS BANCO,
  usr.cuenta AS CLABE,
  date (bon.`Fecha de Calculo`) AS 'Fecha de Calculo',
  bon.`Usuarios Activos`,
  ran.`idtRangoBonos`,
  CONCAT('$', FORMAT((ran.Monto * bon.`Usuarios Activos` * .94), 2)) AS MONTO
FROM egbusiness_members AS usr,
     tBonos AS bon,
     tRangoBonos AS ran
WHERE usr.userid = bon.egbusiness_members_userid
AND bon.`tRangoBonos_idtRangoBonos` = ran.`idtRangoBonos`
AND bon.`Fecha de Calculo` = vFecha
ORDER BY (ran.Monto * bon.`Usuarios Activos`) DESC, `Usuarios Activos` DESC, NOMBRE ASC;
END
$$