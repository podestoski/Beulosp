DROP PROCEDURE IF EXISTS sp_consultaActivosCorreos$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaActivosCorreos()
begin
	if exists ( SELECT
    *
  FROM egbusiness_members usr
    JOIN temp_usrActivadoPorFraccionado tmp
      ON usr.userid = tmp.idUsuario
      AND date (tmp.fecha) = CURDATE()) THEN
SELECT
  CONCAT('<html>
		<h3>Se debe activar al siguiente usuario debido a que alcanz&oacute; un movimiento con sus movimientos fraccionados.<h3>
		<br>
		<table border="1px">
			<tr>
				<td>idUsuario</td>
				<td>Nombre</td>
				<td>loginid</td>
			</tr>
			<tr>
				<td>', usr.userid, '</td>',
  '<td>', usr.name_l, usr.name_f, '</td>',
  '<td>', usr.loginid, '</td>',
  '</tr>') AS correo
FROM egbusiness_members usr
  JOIN temp_usrActivadoPorFraccionado tmp
    ON usr.userid = tmp.idUsuario
    AND date (tmp.fecha) = CURDATE();
ELSE
SELECT
  'No';
END IF;
END
$$