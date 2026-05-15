#Automação de relatório
USE chocolatesales;

DELIMITER $$

CREATE PROCEDURE filtro_vendas(IN p_semestre VARCHAR(20), IN p_produto VARCHAR(255))
BEGIN
    WITH SalesCalculated AS (
        SELECT 
            product_id,
            quantity,
            profit,
            CONCAT(YEAR(order_date), '.', IF(MONTH(order_date) <= 6, '1', '2')) AS semester
        FROM sales
    )
    SELECT
        p.product_name,
        s.semester,
        CAST(SUM(s.quantity) AS UNSIGNED) AS total_product_sold,
        ROUND(SUM(s.profit), 2) AS total_profit,
        ROUND(AVG(s.quantity), 2) AS avg_product_sold
    FROM SalesCalculated s
    JOIN products p ON s.product_id = p.product_id
    WHERE 
        (p.product_name = p_produto OR p_produto IS NULL)
        AND (s.semester = p_semestre OR p_semestre IS NULL)
    GROUP BY p.product_name, s.semester;
END$$

DELIMITER ;

#CALL filtro_vendas(NULL, "White Chocolate 60%");

