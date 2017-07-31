DROP PROCEDURE IF EXISTS sp_consultar_movimientos_no_calculados$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultar_movimientos_no_calculados()
begin
SELECT
  `tMovimiento`.`idtMovimiento`,
  `tMovimiento`.`tTipoMovimiento_idtTipoMovimiento`,
  `tMovimiento`.`Referencia`,
  `tMovimiento`.`FechaMovimiento`,
  `tMovimiento`.`tTipoPago_idtTipoPago`,
  `tMovimiento`.`tBanco_idtBanco`,
  `tMovimiento`.`tProducto_idtProducto`,
  `tMovimiento`.`Activado`,
  `tMovimiento`.`Contado`,
  `tMovimiento`.`usuarioMovimiento`,
  `tMovimiento`.`otroBanco`,
  `tMovimiento`.`usuarioAlta`
FROM `goytia_mlmyg2012`.`tMovimiento`
WHERE contado = 0
ORDER BY Activado ASC;
END
$$