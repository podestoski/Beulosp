DROP PROCEDURE IF EXISTS sp_consultaHistoricoBonos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaHistoricoBonos(pFecha date)
begin
SELECT
  userid,
  NOMBRE,
  BANCO,
  CLABE,
  `Fecha de Calculo`,
  `Usuarios Activos`,
  `idtRangoBonos`,
  CONCAT('$', MONTO) AS MONTO
FROM (SELECT
    userid,
    NOMBRE,
    BANCO,
    CLABE,
    `Fecha de Calculo`,
    `Usuarios Activos`,
    `idtRangoBonos`,
    FORMAT(MONTO, 2) AS MONTO
  FROM (SELECT
      usr.loginid AS userid,
      CONCAT(usr.name_l, ' ', usr.name_f) AS NOMBRE,
      usr.banco AS BANCO,
      usr.cuenta AS CLABE,
      date (bon.`Fecha de Calculo`) AS 'Fecha de Calculo',
      bon.`Usuarios Activos`,
      ran.`idtRangoBonos`,
      ran.Monto AS MONTO
    FROM egbusiness_members AS usr,
         tHBonos AS bon,
         tRangoBonos AS ran
    WHERE usr.userid = bon.egbusiness_members_userid
    AND bon.`tRangoBonos_idtRangoBonos` = ran.`idtRangoBonos`
    AND date (bon.`Fecha de Calculo`) = date (pFecha)
    ORDER BY MONTO DESC, `Usuarios Activos` DESC, NOMBRE ASC) AS a) AS b;
END
$$