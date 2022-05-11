DROP PROCEDURE IF EXISTS usp_division;

DELIMITER $$

CREATE PROCEDURE usp_Division(IN a DECIMAL(65, 10), IN b DECIMAL(65, 10))
main:BEGIN
    IF (a IS NULL) THEN
        SELECT "Invalid input";
	ELSEIF (b IS NULL) THEN
    	SELECT "Invalid input";
    ELSEIF (b = 0) THEN
        SELECT "Cannot divide by zero";
    ELSE
    	SELECT a/b AS 'result';
    END IF;
END main$$

DELIMITER ;

DROP PROCEDURE IF EXISTS usp_TrapezoidArea;

DELIMITER $$

CREATE PROCEDURE usp_TrapezoidArea(IN a DECIMAL(65, 10), b DECIMAL(65, 10), h DECIMAL(65,10))
main:BEGIN
    IF a IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSEIF b IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSEIF h IS NULL THEN
        SELECT 'Invalid inputs' AS 'Err';
    ELSE
        SELECT ((a+b)*h/2) AS 'result';    
    END IF;
END main$$

DELIMITER ;

DROP PROCEDURE IF EXISTS usp_Calculator;

DELIMITER $$

CREATE PROCEDURE usp_Calculator(IN a DECIMAL(65, 10), b DECIMAL(65, 10), operand VARCHAR(255))
main:BEGIN
    DECLARE result DECIMAL(65, 10);
    IF (a IS NULL) OR (b IS NULL) OR (operand LIKE '') OR (operand LIKE "%'%") THEN
        SELECT 'Invalid Input';
        LEAVE main;
    END IF;
    SET result= (
        CASE
            WHEN (operand LIKE 'ADD') THEN a+b
            WHEN (operand LIKE 'SUB') THEN a-b
            WHEN (operand LIKE 'MUL') THEN a*b
            WHEN (operand LIKE 'DIV') THEN a/b
            WHEN (operand LIKE 'POW') THEN POW(a,b)
        END
    );
    PREPARE dynamic_stmt FROM CONCAT("SELECT IFNULL(?, 'Invalid input') AS '", operand, "';");
    EXECUTE dynamic_stmt USING result;
    DEALLOCATE PREPARE dynamic_stmt;
END main$$

DELIMITER ;

-- ej1 (winter)
DROP PROCEDURE IF EXISTS search_by_date;

DELIMITER //
CREATE PROCEDURE search_by_date(IN fecha DATE)
BEGIN
    SELECT * FROM personal WHERE fechaAlta <= fecha AND fechaBaja >= fecha; 
END //

DELIMITER ;

-- ej2 (kupa)
DROP PROCEDURE IF EXISTS usp_SearchBySurname;

DELIMITER $$

CREATE PROCEDURE usp_SearchBySurname(IN surname VARCHAR(50))
main:BEGIN
    DECLARE string_query VARCHAR(50) DEFAULT '%';
    IF surname NOT LIKE '' THEN
        SET string_query = CONCAT('%', surname, '%');
    END IF;
    SELECT * FROM clientes WHERE (apellido1 LIKE string_query) OR (apellido2 LIKE string_query);
END main$$

DELIMITER ;

-- ej4
DROP PROCEDURE IF EXISTS usp_NewClient;

DELIMITER $$

CREATE PROCEDURE usp_NewClient(
    IN codigo INT(11),
    IN nif CHAR(12),
    IN nombre CHAR(50),
    IN apellido1 CHAR(50),
    IN apellido2 CHAR(50),
    IN telefono CHAR(12),
    IN calle CHAR(100),
    IN numero CHAR(4),
    IN letra CHAR(1),
    IN piso CHAR(3),
    IN puerta CHAR(2),
    IN observaciones VARCHAR(200),
    IN localidades CHAR(3)
)
main:BEGIN
    IF (
        CASE
            WHEN (codigo IS NULL)    OR (codigo = '')    THEN 1
            WHEN (nif IS NULL)       OR (nif = '')       THEN 1
            WHEN (nombre IS NULL)    OR (nombre = '')    THEN 1
            WHEN (apellido1 IS NULL) OR (apellido1 = '') THEN 1
            WHEN (telefono IS NULL)  OR (telefono = '')  THEN 1
            WHEN (calle IS NULL)     OR (calle = '')     THEN 1
            WHEN (numero IS NULL)    OR (numero = '')    THEN 1
            WHEN (localidades IS NULL) OR (localidades = '') THEN 1
            ELSE 0
        END
    ) THEN
        SELECT 'Invalid input';
        LEAVE main;
    END IF;
    INSERT INTO clientes VALUES (codigo, nif, nombre, apellido1, apellido2, telefono, calle, numero, letra, piso, puerta, observaciones, localidades);
END main$$

DELIMITER ;

-- ej 6
DROP PROCEDURE IF EXISTS usp_SearchByZone;

DELIMITER $$

CREATE PROCEDURE usp_SearchByZone(IN a CHAR(3))
main:BEGIN
    SELECT * FROM clientes WHERE localidades LIKE a;
END main$$

DELIMITER ;

-- ej 8
DROP PROCEDURE IF EXISTS usp_FormerEmployees;

DELIMITER $$

CREATE PROCEDURE usp_FormerEmployees(IN unemploymentDate DATE)
main:BEGIN
    SELECT * FROM personal WHERE personal.FechaBaja >= unemploymentDate;
END main$$

DELIMITER ;

-- ej 10

DROP PROCEDURE IF EXISTS usp_PriceUp;

DELIMITER $$

CREATE PROCEDURE usp_PriceUp()
main:BEGIN
    UPDATE bases SET importe= importe*1.2;
END main$$

DELIMITER ;

-- ej 12

DROP PROCEDURE IF EXISTS usp_TodaysRequest;

DELIMITER $$

CREATE PROCEDURE usp_TodaysRequest()
main:BEGIN
    SELECT pedidos.codigo, estados.descripcion FROM pedidos LEFT JOIN estados ON pedidos.estado = estados.codigo WHERE DATE(pedidos.FechaHoraPedido) = CURRENT_DATE();
END main$$

DELIMITER ;

-- ej 14

DROP PROCEDURE IF EXISTS usp_SuccessfulRequests;

DELIMITER $$

CREATE PROCEDURE usp_SuccessfulRequests()
main:BEGIN
    SELECT * FROM pedidos WHERE pedidos.estado LIKE 'ENT' ORDER BY pedidos.estado ASC;
END main$$

DELIMITER ;

-- ej 16

DROP PROCEDURE IF EXISTS usp_ClearUnsuccessfulRequests;

DELIMITER $$

CREATE PROCEDURE usp_ClearUnsuccessfulRequests(IN clearBefore DATE)
main:BEGIN
    IF (clearBefore IS NULL) THEN 
        SELECT 'Invalid input';
        LEAVE main;
    END IF;
    DELETE FROM pedidos WHERE pedidos.estado IN ('CAN', 'PEN') AND pedidos.FechaHoraPedido < clearBefore;
END main$$

DELIMITER ;

-- ej 18

DROP PROCEDURE IF EXISTS usp_ViewPendingRequests;

DELIMITER $$

CREATE PROCEDURE usp_ViewPendingRequests(IN viewBefore DATE)
main:BEGIN
    IF (clearBefore IS NULL) THEN 
        SELECT 'Invalid input';
        LEAVE main;
    END IF;
        SELECT * FROM pedidos WHERE pedidos.estado LIKE 'PEN' AND pedidos.FechaHoraPedido < viewBefore;
END main$$

DELIMITER ;

-- ej20

DROP PROCEDURE IF EXISTS usp_ComputeRequestCost;

DELIMITER $$

CREATE PROCEDURE usp_ComputeRequestCost(IN requestId INT)
main:BEGIN
    DECLARE paymentMethod VARCHAR(3);
    IF (requestId IS NULL) THEN
        SELECT 'Invalid input';
        LEAVE main;
    END IF;
    SET paymentMethod= (SELECT pago FROM pedidos WHERE pedidos.codigo = requestId);
    IF (paymentMethod LIKE 'EFE') THEN
        SELECT (importe*0.9) AS 'Bonificacion' FROM pedidos WHERE pedidos.codigo = requestId;
    ELSE
        SELECT (importe*1.05) AS 'Recargo' FROM pedidos WHERE pedidos.codigo = requestId;
    END IF; 
END main$$

DELIMITER ;