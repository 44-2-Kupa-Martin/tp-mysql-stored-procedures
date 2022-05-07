USE test;
DROP PROCEDURE IF EXISTS division;

DELIMITER $$

CREATE PROCEDURE division(IN a DECIMAL(65, 10), IN b DECIMAL(65, 10))
BEGIN
    IF (a IS NULL) THEN
        SELECT "Invalid input";
	ELSEIF (b IS NULL) THEN
    	SELECT "Invalid input";
    ELSEIF (b = 0) THEN
        SELECT "Cannot divide by zero";
    ELSE
    	SELECT a/b AS 'result';
    END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS test;

DELIMITER $$

CREATE PROCEDURE test()
BEGIN
    IF @num1 IS NULL THEN
        SET @num1 = 0;
    END IF;
    IF @num2 IS NULL THEN
        SET @num2 = 1;
    END IF;
    SET @num1 = @num1 + @num2;
    SELECT @num1;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS trapezoid_area;

DELIMITER $$

CREATE PROCEDURE trapezoid_area(IN a DECIMAL(65, 10), b DECIMAL(65, 10), h DECIMAL(65,10))
BEGIN
    IF a IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSEIF b IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSEIF h IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSE
        SELECT ((a+b)*h/2) AS 'result';    
    END IF;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS search_by_date;

DELIMITER //
CREATE PROCEDURE search_by_date(IN fecha DATE)
BEGIN
    SELECT * FROM personal WHERE fechaAlta <= fecha AND fechaBaja >= fecha; 
END //

DELIMITER ;

CALL search_by_date ("2010/08/01");

DROP PROCEDURE IF EXISTS search_by_surname;

DELIMITER $$

CREATE PROCEDURE search_by_surname(IN surname VARCHAR(50))
BEGIN
    DECLARE string_query VARCHAR(50) DEFAULT '%';
    IF surname NOT LIKE '' THEN
        SET string_query = CONCAT('%', surname, '%');
    END IF;
    SELECT * FROM clientes WHERE (apellido1 LIKE string_query) OR (apellido2 LIKE string_query);
END$$

DELIMITER ;


CALL search_by_surname('muoz');