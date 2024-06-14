
WITH tb_idade_base AS (
    SELECT 
        t2.seller_id,
        MAX(JULIANDAY('2017-04-01') - JULIANDAY(t1.order_approved_at)) AS idade_base
    FROM     
        tb_orders AS t1

        LEFT JOIN tb_order_items AS t2
            ON t1.order_id = t2.order_id

    WHERE t1.order_approved_at < '2017-04-01'
        AND t1.order_status = 'delivered'

    GROUP BY t2.seller_id
)

SELECT  
    t2.seller_id,
    t3.idade_base AS idade_base_dias,
    1 + CAST(t3.idade_base / 30 AS INTEGER) AS idade_base_mes,

    COUNT(DISTINCT STRFTIME('%m', t1.order_approved_at)) AS qtde_mes_ativacao, 
    CAST( COUNT( DISTINCT STRFTIME('%m', t1.order_approved_at)) AS FLOAT) / MIN(1 + CAST(t3.idade_base / 30 AS INTEGER), 6) AS prop_ativacao,

    SUM(t2.price) AS receita_total,
    SUM(t2.price) / COUNT(DISTINCT t2.order_id) AS avg_vl_venda,
    SUM(t2.price) / MIN(1 + CAST(t3.idade_base / 30 AS INTEGER), 6) AS avg_vl_venda_mes,
    SUM(t2.price) / COUNT(DISTINCT STRFTIME('%m', t1.order_approved_at)) AS avg_vl_venda_mes_ativado,
    
    COUNT(t2.product_id) AS qtde_produto,
    COUNT(DISTINCT t2.product_id) AS qtde_produto_dst,
    SUM(t2.price) / COUNT(t2.product_id) AS avg_vl_produto,
    COUNT(t2.product_id) / COUNT(DISTINCT t2.order_id) AS avg_qtd_produto_venda

FROM tb_orders AS t1

LEFT JOIN tb_order_items AS t2 
    ON t1.order_id = t2.order_id

LEFT JOIN tb_idade_base AS t3
    ON t2.seller_id = t3.seller_id

WHERE t1.order_approved_at BETWEEN '2016-10-01' AND '2017-04-01'
    AND t1.order_status = 'delivered'

GROUP BY t2.seller_id;
