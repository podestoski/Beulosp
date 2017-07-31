DROP PROCEDURE IF EXISTS sp_agruparFraccionados$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_agruparFraccionados()
begin
	declare vMontoAgrupar 		float;
    declare done 				INT;
    declare montoAgregado 		float;
    declare cur_idUsuario 		int;
    declare cur_idMovimiento 	int;
    declare	cur_monto 			float;
    declare sp_id 				int;
    declare countrow 			int;
    declare iterator 			int;
    declare idMovit 			int;
    declare maxExc				int;
    
    DECLARE 	cursorAgrupados 
	cursor for
SELECT
  idUsuario
FROM com_movimientosFraccionados
GROUP BY idUsuario
HAVING SUM(monto) >= vMontoAgrupar;

DECLARE cursorFraccionados CURSOR FOR
SELECT
  id,
  monto
FROM com_movimientosFraccionados
WHERE idUsuario = cur_idUsuario
ORDER BY monto ASC;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

SELECT
  costo INTO vMontoAgrupar
FROM com_esquema
WHERE id = 1;
    
    drop table if exists tempMov;
    CREATE TEMPORARY TABLE tempMov (idMov int null);
 
	
    SET done = 0;

DELETE
  FROM temp_usrActivadoPorFraccionado;
    
    
    open cursorAgrupados;
	read_loop: LOOP
        
        FETCH cursorAgrupados INTO 	cur_idUsuario;
        
        IF done THEN
		  LEAVE read_loop;
		END IF;
        
        set montoAgregado = 0;
        open cursorFraccionados;
		read_loop2: LOOP
        
			FETCH cursorFraccionados INTO cur_idMovimiento,cur_monto;
            IF done THEN
				LEAVE read_loop2;
			END IF;
			set montoAgregado = montoAgregado + cur_monto;
INSERT INTO tempMov
  VALUES (cur_idMovimiento);
			
			if(montoAgregado >= vMontoAgrupar)
			then
CALL `sp_insertar_tMovimiento`(2, "Generado de Movimientos Fraccionados", NOW(), 1, 0, 1, 1, cur_idUsuario, "Fraccionado", cur_idUsuario, "Se genera de movimientos fraccionados", montoAgregado, 1, sp_id);
INSERT INTO com_rel_fraccionadoMovimiento (idfraccionado, idMovimiento, fecha)
  SELECT
    idMov,
    sp_id,
    NOW()
  FROM tempMov;
SELECT
  COUNT(*) INTO countrow
FROM tempMov;
				set iterator = 0;
                if(montoAgregado > vMontoAgrupar) /*Se guarda el excedente*/
                then
INSERT INTO com_movimientosFraccionados (referencia, fechaMovimiento, fechaCaptura, idBanco, monto, descripcion, idUsuario, otroBanco)
  SELECT
    "Excedente",
    FechaMovimiento,
    fechaCaptura,
    0,
    (montoAgregado - vMontoAgrupar),
    "Excedente de fraccionados",
    idUsuario,
    "Excedente de Fraccionado"
  FROM com_movimientosFraccionados
  WHERE id = cur_idMovimiento;
SELECT
  MAX(id) INTO maxExc
FROM com_movimientosFraccionados;
INSERT INTO com_rel_excendenteMovimiento (idMovimiento, idFraccionado, fecha)
  VALUES (sp_id, maxExc, NOW());
END IF;
                set montoAgregado = 0;
				while (iterator <= countrow)
				do
SELECT
  idMov INTO idMovit
FROM tempMov
ORDER BY idMov DESC LIMIT 1;
                    set done = 0;
CALL `sp_pasoHistoricoMovimientoFraccionado`(idMovit, 'Agregado a Mov');
					set iterator = iterator + 1;
DELETE
  FROM tempMov
WHERE idMov = idMovit;
END WHILE;
INSERT INTO temp_usrActivadoPorFraccionado
  VALUES (cur_idUsuario, NOW(), sp_id);
END IF;

END LOOP;
        
        CLOSE cursorFraccionados;
        
        set done = 0;
        
        set montoAgregado = 0;
DELETE
  FROM tempMov;

END LOOP;
		
	CLOSE cursorAgrupados;
    
end
$$