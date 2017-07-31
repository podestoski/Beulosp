DROP PROCEDURE IF EXISTS sp_consultaFraccionados$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaFraccionados()
begin
SELECT
  mov.id,
  mov.referencia,
  mov.fechaMovimiento,
  mov.fechaCaptura,
  CASE mov.idBanco WHEN 0 THEN mov.otroBanco ELSE ban.Descripcion END AS Descripcion,
  CONCAT('$', FORMAT(mov.monto, 2)) AS monto,
  mem.loginid,
  CONCAT(mem.name_f, ' ', mem.name_l) AS nombre
FROM com_movimientosFraccionados mov
  JOIN tBanco ban
    ON mov.idBanco = ban.idtBanco
  JOIN egbusiness_members mem
    ON mov.idUsuario = mem.userid;

END
$$