with customer_frequency as (
  select 
    customer.customer_unique_id,
    count(distinct order_id) as order_cnt
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset` as orders
  join `project_name.Brazilian_ECommerce_Olist.olist_customers_dataset` as customer
    on orders.customer_id = customer.customer_id
  where orders.order_status not in  ('canceled', 'unavailable')
    and orders.order_approved_at IS NOT NULL
  group by customer.customer_unique_id
)

select
  count(*) as purchased_1_plus,
  countif(order_cnt >= 2) as purchased_2_plus,
  countif(order_cnt >= 3) as purchased_3_plus,
  countif(order_cnt >= 4) as purchased_4_plus,
  round(countif(order_cnt >= 2) *100.0 / count(*) ,2 ) as purchased_1_to_2_rate,
  round(countif(order_cnt >= 3) *100.0 / countif(order_cnt >= 2) ,2 ) as purchased_2_to_3_rate,
  round(countif(order_cnt >= 4) *100.0 / countif(order_cnt >= 3) ,2 ) as purchased_3_to_4_rate
from customer_frequency;
