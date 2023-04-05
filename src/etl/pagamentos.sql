SELECT DATe(dtPedido) as dtPedido,
    count(*) as qtPedido

FROM pedido

GROUP BY 1
ORDER BY 1;

SELECT * FROM pedido

WHERE dtPedido < '2018-01-01'
and dtPedido >= julianday('2018-01-01')