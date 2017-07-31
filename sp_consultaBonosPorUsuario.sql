DROP PROCEDURE IF EXISTS sp_consultaBonosPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaBonosPorUsuario(pusr int)
begin
SELECT
  usr.userid,
  usr.name_f,
  usr.name_l,
  date (bon.`Fecha de Calculo`) AS 'Fecha de Calculo',
  bon.`Usuarios Activos`,
  ran.`idtRangoBonos`,
  CONCAT('$', FORMAT((ran.Monto * bon.`Usuarios Activos` * .94), 2)) AS Monto
FROM egbusiness_members AS usr,
     tBonos AS bon,
     tRangoBonos AS ran
WHERE usr.userid = bon.egbusiness_members_userid
AND bon.`tRangoBonos_idtRangoBonos` = ran.`idtRangoBonos`
AND usr.userid = pusr;
END
$$