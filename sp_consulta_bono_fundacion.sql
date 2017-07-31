DROP PROCEDURE IF EXISTS sp_consulta_bono_fundacion$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_consulta_bono_fundacion()
begin
SELECT
  'Bono FundaciÃ³n',
  FORMAT(Valor, 2) AS Valor
FROM tParametro
WHERE idtParametro = 2;

END
$$