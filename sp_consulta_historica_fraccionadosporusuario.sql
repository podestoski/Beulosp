DROP PROCEDURE IF EXISTS sp_consulta_historica_fraccionadosporusuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_historica_fraccionadosporusuario(pLoginid varchar(255))
begin
SELECT
  his.fechaMovimiento 'Fecha del Movimiento',
  ban.Descripcion 'Banco',
  CONCAT('$', FORMAT(his.monto, 2)) 'Monto',
  his.Descripcion 'Notas',
  CONCAT(usr.name_l, ' ', usr.name_f) 'Nombre',
  his.FechaHistorica 'Fecha Historica',
  his.motivo 'Motivo del Paso a Historico'
FROM com_hMovimientosFraccionados his
  JOIN egbusiness_members usr
    ON usr.loginid = pLoginid
    AND his.idUsuario = usr.userid
  JOIN tBanco ban
    ON ban.idtBanco = his.idBanco
ORDER BY 1 ASC;
END
$$