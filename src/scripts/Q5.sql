CREATE OR REPLACE VIEW vw_painel_vendas_gerencial AS
SELECT
    stores.country,
    stores.store_name,
    COUNT(sales.order_id) AS total_pedidos,
    SUM(sales.quantity) AS total_itens_vendidos,
    ROUND(SUM(sales.cost), 2) AS receita_total,
    ROUND(AVG(sales.cost), 2) AS ticket_medio
FROM sales
INNER JOIN stores
    ON sales.store_id = stores.store_id
GROUP BY
    stores.country,
    stores.store_name
ORDER BY receita_total DESC;

#SELECT * FROM vw_painel_vendas_gerencial;

CREATE OR REPLACE VIEW vw_painel_vendas_detalhadas AS
SELECT
    sales.order_id,
    sales.order_date,
    customers.customer_name,
    products.product_name,
    stores.store_name,
    stores.country,
    sales.quantity,
    ROUND((sales.quantity * sales.cost), 2) AS total_cost,
    ROUND((sales.quantity * sales.revenue), 2) AS total_revenue,
    ROUND((sales.quantity * sales.profit), 2) AS total_profit
FROM sales
INNER JOIN customers
    ON sales.customer_id = customers.customer_id
INNER JOIN products
    ON sales.product_id = products.product_id
INNER JOIN stores
    ON sales.store_id = stores.store_id;

#SELECT * FROM vw_painel_vendas_detalhadas;