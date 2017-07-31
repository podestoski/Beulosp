DROP PROCEDURE IF EXISTS sp_insertarBono$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_insertarBono(IN pUsuario int, IN pActivos int)
BEGIN

DELETE
  FROM tHBonos
WHERE TIMESTAMPDIFF(DAY, FechaHist, CURDATE()) > 365;

INSERT INTO tHBonos (egbusiness_members_userid, `Fecha de Calculo`, `Usuarios Activos`, `tRangoBonos_idtRangoBonos`, `FechaHist`)
  SELECT
    egbusiness_members_userid,
    `Fecha de Calculo`,
    `Usuarios Activos`,
    `tRangoBonos_idtRangoBonos`,
    CURDATE()
  FROM tBonos
  WHERE egbusiness_members_userid = pUsuario;

DELETE
  FROM tBonos
WHERE egbusiness_members_userid = pUsuario;

INSERT INTO tBonos (egbusiness_members_userid, `Fecha de Calculo`, `Usuarios Activos`, `tRangoBonos_idtRangoBonos`)
  SELECT
    pUsuario,
    CURDATE(),
    pActivos,
    idtRangoBonos
  FROM tRangoBonos
  WHERE pActivos >= limiteInferior
  AND pActivos <= limiteSuperior;

END
$$