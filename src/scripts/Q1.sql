--- Panorama temporal e ranking
USE chocolatesales;

CREATE VIEW vw_ranking (store, sales_quantity) AS
SELECT s.store_name, q.quantity
FROM stores s
INNER JOIN sales q
ON q.store_id = s.store_id;