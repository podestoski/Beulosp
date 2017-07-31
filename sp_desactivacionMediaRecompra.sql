
DROP PROCEDURE IF EXISTS sp_desactivacionMediaRecompra$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_desactivacionMediaRecompra()
begin
/*Desactivar aquellos que tienen 15*/
UPDATE egbusiness_members
SET userlevel = 0
WHERE userid IN (SELECT
    des.userid
  FROM tDesactivacion AS des
  WHERE TIMESTAMPDIFF(DAY, des.fechaRegistro, CURDATE()) > 14);

/*Pasar al histórico*/
INSERT INTO tHDesactivacion (userid, fechaRegistro, fechaPaso)
  SELECT
    userid,
    fechaRegistro,
    CURDATE()
  FROM tDesactivacion
  WHERE TIMESTAMPDIFF(DAY, fechaRegistro, CURDATE()) > 14;

/*Limpiar el histórico*/
DELETE
  FROM tHDesactivacion
WHERE TIMESTAMPDIFF(DAY, fechaPaso, CURDATE()) > 365;


/*Quitar los que ya se borraron*/
DELETE
  FROM tDesactivacion
WHERE TIMESTAMPDIFF(DAY, fechaRegistro, CURDATE()) > 14;

END
$$