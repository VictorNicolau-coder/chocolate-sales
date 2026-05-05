--- Panorama temporal e ranking
USE chocolatesales;

CREATE OR REPLACE VIEW vw_ranking AS
SELECT stores.store_name, SUM(sales.quantity) AS totalQuantity, stores.country
FROM sales 
INNER JOIN stores ON sales.store_id = stores.store_id
WHERE order_date BETWEEN '2024-12-01' AND '2024-12-31'
    AND country = 'Germany'
GROUP BY stores.store_name
ORDER BY totalQuantity DESC;