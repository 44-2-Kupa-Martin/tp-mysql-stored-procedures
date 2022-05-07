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

DROP PROCEDURE IF EXISTS calculator;

DELIMITER $$

CREATE PROCEDURE calculator(IN a DECIMAL(65, 10), b DECIMAL(65, 10), operand VARCHAR(3))
main:BEGIN
    IF (a IS NULL) OR (b IS NULL) OR (operand LIKE '') THEN
        SELECT 'Invalid Input';
        LEAVE main;
    END IF;
    PREPARE dynamic_stmt FROM CONCAT(
    "SELECT
        (CASE
            WHEN '", operand, "' LIKE 'ADD' THEN ", a, "+", b,"
            WHEN '", operand, "' LIKE 'SUB' THEN ", a, "-", b,"
            WHEN '", operand, "' LIKE 'MUL' THEN ", a, "*", b,"
            WHEN '", operand, "' LIKE 'DIV' THEN ", a, "/", b,"
            WHEN '", operand, "' LIKE 'POW' THEN POW(", a, ",", b, ")
            ELSE 'Invalid operand'
        END)
    AS '", operand, "';");
    EXECUTE dynamic_stmt;
    DEALLOCATE PREPARE dynamic_stmt;
END main$$