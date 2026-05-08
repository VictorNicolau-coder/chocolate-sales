#Garantia de regra de negócio

USE chocolatesales;

DELIMITER $$

CREATE TRIGGER trg_sales_before_insert
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        
        INSERT INTO sales_audit_log (
            timestamp,
            user,
            operation,
            problem,
            sql_text
        )
        VALUES (
            NOW(),
            CURRENT_USER(),
            'INSERT',
            'Tentativa de inserir venda com quantidade <= 0',
            'INSERT INTO sales ...'
        );

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: quantidade de venda inválida (<= 0)';
    
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_sales_before_update
BEFORE UPDATE ON sales
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        
        INSERT INTO sales_audit_log (
            timestamp,
            user,
            operation,
            problem,
            sql_text
        )
        VALUES (
            NOW(),
            CURRENT_USER(),
            'UPDATE',
            'Tentativa de atualizar venda com quantidade <= 0',
            'UPDATE sales ...'
        );

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro: quantidade de venda inválida (<= 0)';
    
    END IF;
END$$

DELIMITER ;

INSERT INTO sales(order_id, order_date, product_id, store_id, customer_id, quantity, unit_price, discount, revenue, cost, profit) 
VALUES ("0RD000TEST1", "2024-03-10", "P0047", "S049", "C049903", 0, 4.56, 0, 0, 0, 0);

UPDATE sales 
SET quantity = 0 
WHERE order_id = "0RD00000001";

SELECT * FROM sales_audit_log;


