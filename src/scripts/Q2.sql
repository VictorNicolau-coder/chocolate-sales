CREATE OR REPLACE VIEW vw_monitoramento_vendas AS
WITH vendas_lojas AS (
    SELECT
        stores.store_id,
        stores.store_name,
        stores.country,
        YEAR(sales.order_date) AS ano,
        MONTH(sales.order_date) AS mes,
        ROUND(SUM(sales.profit), 2) AS lucro_total
    FROM sales
    INNER JOIN stores ON sales.store_id = stores.store_id
    GROUP BY
        stores.store_id,
        stores.store_name,
        stores.country,
        YEAR(sales.order_date),
        MONTH(sales.order_date)
),
media_global AS (SELECT ROUND(AVG(lucro_total), 2) AS media_lucro FROM vendas_lojas)
SELECT
    v.store_id,
    v.store_name,
    v.country,
    v.ano,
    v.mes,
    v.lucro_total,
    m.media_lucro,
    ROUND(((v.lucro_total / m.media_lucro) * 100), 2) AS percentual_media,
    CASE
        WHEN v.lucro_total >= (m.media_lucro * 1.2)
            THEN 1
        WHEN v.lucro_total >= (m.media_lucro * 1.1)
            THEN 2
        ELSE 3
    END AS prioridade
FROM vendas_lojas v
CROSS JOIN media_global m
WHERE v.lucro_total >= m.media_lucro;

SELECT * FROM vw_monitoramento_vendas;