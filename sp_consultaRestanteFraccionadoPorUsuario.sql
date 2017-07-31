DROP PROCEDURE IF EXISTS sp_consultaRestanteFraccionadoPorUsuario$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consultaRestanteFraccionadoPorUsuario(pIdUsuario int)
begin
	  declare valorAjuntar float;
    declare totalUsuario float;
SELECT
  Valor INTO valorAjuntar
FROM tParametro
WHERE idtParametro = 7;
SELECT
  (valorAjuntar - SUM(monto)) INTO totalUsuario
FROM com_acumuladoUsuario mov
WHERE mov.idUsuario = pIdUsuario;
    

    if(totalUsuario is null)
    then
SELECT
  '$1500.00' AS monto;
ELSE
		  if(totalUsuario < 0)
		  then
			  set totalUsuario = 0;
		  end if;
SELECT
  CONCAT('$', FORMAT(totalUsuario, 2)) AS monto;
END IF;
END
$$