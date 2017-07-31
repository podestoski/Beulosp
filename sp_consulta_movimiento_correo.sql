DROP PROCEDURE IF EXISTS sp_consulta_movimiento_correo$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_movimiento_correo(pidMovimiento int)
BEGIN
	declare vidBanco int;
    declare vidtipoMov int;
SELECT
  tBanco_idtBanco INTO vidBanco
FROM tMovimiento
WHERE idtMovimiento = pidMovimiento;
SELECT
  tTipoMovimiento_idtTipoMovimiento INTO vidtipoMov
FROM tMovimiento
WHERE idtMovimiento = pidMovimiento;
	if(vidBanco = 0)/*Es otro Banco*/
    then
		if(vidtipoMov > 2)
        then
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
								<h1>Se ha reportado un nuevo pago</h1>
								<table border="1" style="border-color:black;">
									<tr>
										<td class="descr"><b>Nombre</b></td>
										<td align="right">', CONCAT(mem.name_l, ' ', mem.name_f), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Login Id</b></td>
										<td align="right">', mem.loginId, '</td>
									</tr>
									<tr>
										<td class="descr"><b>TipoMovimiento</b></td>
										<td align="right">', tMov.`Descripcion`, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Fecha</b></td>
										<td align="right">', mov.FechaMovimiento, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Referencia</b></td>
										<td align="right">', mov.Referencia, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Banco</b></td>
										<td align="right">', mov.otroBanco, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Monto</b></td>
										<td align="right">', CONCAT('$', FORMAT(Monto, 2)), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Nivel</b></td>
										<td align="right">', UPPER(esq.descripcion), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Comentarios</b></td>
										<td align="right">', mov.comentario, '</td>
									</tr>
								</table>
								<h5><i>Favor de revisar y en caso que as&iacute; proceda,validarlo.</i></h5>
							</body>
						</html>')
FROM tMovimiento mov
  JOIN tTipoMovimiento tMov
    ON mov.tTipoMovimiento_idtTipoMovimiento = tMov.idtTipoMovimiento
  JOIN egbusiness_members mem
    ON mov.usuarioMovimiento = mem.userid
  JOIN com_esquema esq
    ON mov.nivel = esq.id
WHERE mov.idtMovimiento = pidMovimiento;
ELSE
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
								<h1>Se ha reportado un nuevo pago</h1>
								<table border="1" style="border-color:black;">
									<tr>
										<td class="descr"><b>Nombre</b></td>
										<td align="right">', CONCAT(mem.name_l, ' ', mem.name_f), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Login Id</b></td>
										<td align="right">', mem.loginId, '</td>
									</tr>
									<tr>
										<td class="descr"><b>TipoMovimiento</b></td>
										<td align="right">', tMov.`Descripcion`, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Fecha</b></td>
										<td align="right">', mov.FechaMovimiento, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Referencia</b></td>
										<td align="right">', mov.Referencia, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Banco</b></td>
										<td align="right">', mov.otroBanco, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Monto</b></td>
										<td align="right">', CONCAT('$', FORMAT(Monto, 2)), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Nivel</b></td>
										<td align="right">', UPPER(esq.descripcion), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Comentarios</b></td>
										<td align="right">', mov.comentario, '</td>
									</tr>
								</table>
								<h5><i>Favor de revisar y en caso que as&iacute; proceda,validarlo.</i></h5>
							</body>
						</html>')
FROM tMovimiento mov
  JOIN tTipoMovimiento tMov
    ON mov.tTipoMovimiento_idtTipoMovimiento = tMov.idtTipoMovimiento
  JOIN egbusiness_members mem
    ON mov.usuarioMovimiento = mem.userid
  JOIN tBanco ban
    ON mov.tBanco_idtBanco = ban.idtBanco
  JOIN com_esquema esq
    ON esq.id = mov.nivel
WHERE mov.idtMovimiento = pidMovimiento;
END IF;
ELSE/*Tiene Banco*/
		if(vidtipoMov > 2)
        then
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
								<h1>Se ha reportado un nuevo pago</h1>
								<table border="1" style="border-color:black;">
									<tr>
										<td class="descr"><b>Nombre</b></td>
										<td align="right">', CONCAT(mem.name_l, ' ', mem.name_f), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Login Id</b></td>
										<td align="right">', mem.loginId, '</td>
									</tr>
									<tr>
										<td class="descr"><b>TipoMovimiento</b></td>
										<td align="right">', tMov.`Descripcion`, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Fecha</b></td>
										<td align="right">', mov.FechaMovimiento, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Referencia</b></td>
										<td align="right">', mov.Referencia, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Banco</b></td>
										<td align="right">', ban.Descripcion, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Monto</b></td>
										<td align="right">', CONCAT('$', FORMAT(Monto, 2)), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Nivel</b></td>
										<td align="right">', UPPER(esq.descripcion), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Comentarios</b></td>
										<td align="right">', mov.comentario, '</td>
									</tr>
								</table>
								<h5><i>Favor de revisar y en caso que as&iacute; proceda,validarlo.</i></h5>
							</body>
						</html>')
FROM tMovimiento mov
  JOIN tTipoMovimiento tMov
    ON mov.tTipoMovimiento_idtTipoMovimiento = tMov.idtTipoMovimiento
  JOIN egbusiness_members mem
    ON mov.usuarioMovimiento = mem.userid
  JOIN tBanco ban
    ON mov.tBanco_idtBanco = ban.idtBanco
  JOIN com_esquema esq
    ON esq.id = mov.nivel
WHERE mov.idtMovimiento = pidMovimiento;
ELSE
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
								<h1>Se ha reportado un nuevo pago</h1>
								<table border="1" style="border-color:black;">
									<tr>
										<td class="descr"><b>Nombre</b></td>
										<td align="right">', CONCAT(mem.name_l, ' ', mem.name_f), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Login Id</b></td>
										<td align="right">', mem.loginId, '</td>
									</tr>
									<tr>
										<td class="descr"><b>TipoMovimiento</b></td>
										<td align="right">', tMov.`Descripcion`, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Fecha</b></td>
										<td align="right">', mov.FechaMovimiento, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Referencia</b></td>
										<td align="right">', mov.Referencia, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Banco</b></td>
										<td align="right">', ban.Descripcion, '</td>
									</tr>
									<tr>
										<td class="descr"><b>Monto</b></td>
										<td align="right">', CONCAT('$', FORMAT(Monto, 2)), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Nivel</b></td>
										<td align="right">', UPPER(esq.descripcion), '</td>
									</tr>
									<tr>
										<td class="descr"><b>Comentarios</b></td>
										<td align="right">', mov.comentario, '</td>
									</tr>
								</table>
								<h5><i>Favor de revisar y en caso que as&iacute; proceda,validarlo.</i></h5>
							</body>
						</html>')
FROM tMovimiento mov
  JOIN tTipoMovimiento tMov
    ON mov.tTipoMovimiento_idtTipoMovimiento = tMov.idtTipoMovimiento
  JOIN egbusiness_members mem
    ON mov.usuarioMovimiento = mem.userid
  JOIN tBanco ban
    ON mov.tBanco_idtBanco = ban.idtBanco
  JOIN com_esquema esq
    ON esq.id = mov.nivel
WHERE mov.idtMovimiento = pidMovimiento;
END IF;
END IF;
END
$$