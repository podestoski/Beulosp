DROP PROCEDURE IF EXISTS sp_validaLoginid$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_validaLoginid(pLogin Varchar(100))
begin
		IF EXISTS ( SELECT
    userid
  FROM egbusiness_members
  WHERE loginid = pLogin) THEN
SELECT
  userid
FROM egbusiness_members
WHERE loginid = pLogin;
ELSE
SELECT
  -1;
END IF;

END
$$