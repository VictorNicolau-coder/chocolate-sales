#Panorama temporal e ranking
USE chocolatesales;

CREATE OR REPLACE VIEW vw_ranking AS
WITH AggregatedSales AS (
    SELECT 
        CONCAT(YEAR(s.order_date), '.', IF(MONTH(s.order_date) <= 6, '1', '2')) AS semester,
        st.country,
        st.store_name,
        p.product_name,
        SUM(s.quantity) AS total_quantity,
        ROUND(SUM(s.profit), 2) AS total_profit
    FROM sales s 
    JOIN stores st ON s.store_id = st.store_id
    JOIN products p ON s.product_id = p.product_id
    GROUP BY semester, st.country, st.store_name, p.product_name
)
SELECT 
    *,
    DENSE_RANK() OVER (PARTITION BY semester ORDER BY total_profit DESC) AS ranking_position
FROM AggregatedSales
ORDER BY semester DESC, ranking_position ASC;

SELECT * FROM vw_ranking WHERE ranking_position <= 3;