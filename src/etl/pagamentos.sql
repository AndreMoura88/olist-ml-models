WITH tb_join AS (

-- Seleciona os dados de pagamentos e itens de pedido para cada pedido
  -- criado antes de 01/01/2018 e após 6 meses da data de 01/01/2018
  -- onde o vendedor do item é conhecido (não é nulo)

  SELECT t2.*,
         t3.idVendedor

  FROM pedido AS t1

  LEFT JOIN pagamento_pedido AS t2
  ON t1.idPedido = t2.idPedido

  LEFT JOIN item_pedido AS t3
  ON t1.idPedido = t3.idPedido

  WHERE t1.dtPedido < '2018-01-01'
  AND t1.dtPedido >= strftime('%Y-%m-%d', date('2018-01-01', '-6 months'))
  AND t3.idVendedor IS NOT NULL

),

tb_group AS (

-- Agrupa os dados por vendedor e tipo de pagamento,
  -- calculando a quantidade e valor total de pedidos para cada meio de pagamento
  -- e ordenando por vendedor e tipo de pagamento

  SELECT idVendedor,
         descTipoPagamento,
         count(distinct idPedido) as qtdePedidoMeioPagamento,
         sum(vlPagamento) as vlPedidoMeioPagamento

  FROM tb_join

  GROUP BY idVendedor, descTipoPagamento
  ORDER BY idVendedor, descTipoPagamento

)

-- Seleciona os dados de quantidade e valor total de pedidos
-- para cada vendedor e tipo de pagamento,
-- calculando as percentagens em relação ao total de pedidos e ao total do valor

SELECT 
  idVendedor,

  sum(case when descTipoPagamento='boleto' then qtdePedidoMeioPagamento else 0 end) as qtde_boleto_pedido,
  sum(case when descTipoPagamento='credit_card' then qtdePedidoMeioPagamento else 0 end) as qtde_credit_card_pedido,
  sum(case when descTipoPagamento='voucher' then qtdePedidoMeioPagamento else 0 end) as qtde_voucher_pedido,
  sum(case when descTipoPagamento='debit_card' then qtdePedidoMeioPagamento else 0 end) as qtde_debit_card_pedido,

  sum(case when descTipoPagamento='boleto' then vlPedidoMeioPagamento else 0 end) as valor_boleto_pedido,
  sum(case when descTipoPagamento='credit_card' then vlPedidoMeioPagamento else 0 end) as valor_credit_card_pedido,
  sum(case when descTipoPagamento='voucher' then vlPedidoMeioPagamento else 0 end) as valor_voucher_pedido,
  sum(case when descTipoPagamento='debit_card' then vlPedidoMeioPagamento else 0 end) as valor_debit_card_pedido,
  
  sum(case when descTipoPagamento='boleto' then qtdePedidoMeioPagamento else 0 end) / sum(qtdePedidoMeioPagamento) as pct_qtd_boleto_pedido,
  sum(case when descTipoPagamento='credit_card' then qtdePedidoMeioPagamento else 0 end) / sum(qtdePedidoMeioPagamento) as pct_qtd_credit_card_pedido,
  sum(case when descTipoPagamento='voucher' then qtdePedidoMeioPagamento else 0 end) / sum(qtdePedidoMeioPagamento) as pct_qtd_voucher_pedido,
  sum(case when descTipoPagamento='debit_card' then qtdePedidoMeioPagamento else 0 end) / sum(qtdePedidoMeioPagamento) as pct_qtd_debit_card_pedido,

  sum(case when descTipoPagamento='boleto' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_boleto_pedido,
  sum(case when descTipoPagamento='credit_card' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_credit_card_pedido,
  sum(case when descTipoPagamento='voucher' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_voucher_pedido,
  sum(case when descTipoPagamento='debit_card' then vlPedidoMeioPagamento else 0 end) / sum(vlPedidoMeioPagamento) as pct_valor_debit_card_pedido

FROM tb_group

GROUP BY 1;