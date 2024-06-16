SELECT *,
    CASE WHEN JULIANDAY(order_estimated_delivery_date) < JULIANDAY(order_delivered_customer_date) THEN 1 ELSE 0 END AS atraso
 FROM tb_orders