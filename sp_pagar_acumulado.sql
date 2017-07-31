DROP PROCEDURE IF EXISTS sp_pagar_acumulado$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_pagar_acumulado()
BEGIN
	declare curidusuario int;
    declare curmonto int;
    declare curid int;
    declare vdone INT;
    declare vnivelmaximo int;
    declare vnivelactual int;
    declare vmontodividido float;
    declare vpadre int;
    declare vActivosDirectos int;
    
    /*Cursor de los acumulados*/
	DECLARE 	cursorAcumulado 
	cursor for
SELECT
  id,
  idusuario,
  monto
FROM com_acumulado_comision
WHERE contado = 0
AND monto > 0;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET vdone = 1;
    
    SET vdone = 0;

    open cursorAcumulado;
		read_loop: LOOP

		/*Obtenemos datos del movimiento*/
		FETCH cursorAcumulado INTO 	curid,
									curidusuario,
									curmonto;
                                    
		IF vdone = 1 THEN
			LEAVE read_loop;
		END IF;

SELECT
  valor INTO vnivelmaximo
FROM tParametro
WHERE idtParametro = 1;
        set vnivelactual = 0;
        set  vmontodividido = curmonto / vnivelmaximo;
SELECT
  parent INTO vpadre
FROM egbusiness_members
WHERE userid = curidusuario;
        while (vnivelactual < vnivelmaximo)
        do
			if vpadre = 0 then
UPDATE tParametro
SET valor = valor + vmontodividido
WHERE idtParametro = 2;
                set vnivelactual = vnivelactual + 1;
            else
SELECT
  COUNT(*) INTO vActivosDirectos
FROM egbusiness_members
WHERE parent = vpadre
AND userlevel = 1;
				if exists( SELECT
    *
  FROM egbusiness_members
  WHERE (userid = vpadre
  AND userlevel = 1
  AND cuenta <> ''
  AND cuenta IS NOT NULL)
  OR vpadre = 2382) /*Puede cobrar*/
/*if exists(select * from egbusiness_members where (userid = vpadre and userlevel = 1 and cuenta <> '' and cuenta is not null and vActivosDirectos > 2) or vpadre = 2382)*/
THEN
					if exists( SELECT
    *
  FROM tUsuarioComision
  WHERE egbusiness_members_userid = vpadre) THEN
UPDATE tUsuarioComision
SET Monto = Monto + vmontodividido
WHERE egbusiness_members_userid = vpadre;
ELSE
INSERT INTO tUsuarioComision (egbusiness_members_userid, Monto, FechaCalculoComision)
  VALUES (vpadre, vmontodividido, NOW());
END IF;
                    set vnivelactual = vnivelactual + 1;
                end if;
SELECT
  parent INTO vpadre
FROM egbusiness_members
WHERE userid = vpadre;
END IF;
END WHILE;
UPDATE com_acumulado_comision
SET contado = 1,
    fecha = NOW()
WHERE id = curid;
END LOOP;

END
$$