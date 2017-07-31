DROP PROCEDURE IF EXISTS sp_consulta_incentivo_correo$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_incentivo_correo()
BEGIN
	if exists ( SELECT
    CONCAT(usr.name_l, ' ', usr.name_f) AS NOMBRE,
    usr.loginid,
    inc.incentivo
  FROM egbusiness_members usr
    JOIN com_usuarioIncentivo uin
      ON usr.userid = uin.idUsuario
    JOIN com_incentivos inc
      ON inc.id = uin.idIncentivo
  WHERE inc.id >= 5
  AND uin.Fecha = CURDATE()) THEN
SELECT
  CONCAT('<html>
							<head>
								<style type="text/css">
									td{color:#7F00FF;border-bottom-color:Black;border-top-color:Black;border-left-color:Black;border-right-color:Black;}
									h1{color:#4C0099;}
									h5{color:#7F00FF;}
									td.descr{color:#4C0099;}
								</style>
							</head>
							<body>
								<h1>Se ha reportado un nuevo incentivo</h1>
								<table border="1" style="border-color:black;">
									<tr>
										<td class="descr"><b>Nombre</b></td>
										<td align="right">', CONCAT(usr.name_l, ' ', usr.name_f), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Login Id</b></td>
										<td align="right">', usr.loginid, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Incentivo</b></td>
										<td align="right">', inc.incentivo, '</td>
									</tr>
                                    </table>
							</body>
						</html>')
FROM egbusiness_members usr
  JOIN com_usuarioIncentivo uin
    ON usr.userid = uin.idUsuario
  JOIN com_incentivos inc
    ON inc.id = uin.idIncentivo
WHERE inc.id >= 5
AND uin.Fecha = CURDATE();
ELSE
SELECT
  'No';
END IF;
END
$$