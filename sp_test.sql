DROP PROCEDURE IF EXISTS sp_test$$
CREATE DEFINER = 'youngel3'@'%.%.%.%'
PROCEDURE sp_test()
BEGIN
if exists ( SELECT
    *
  FROM egbusiness_members
  WHERE userid = 11274
  AND nivel IS NULL) THEN
SELECT
  1;
END IF;
END
$$