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
  order_cnt,
  count(*) as customer_cnt,
  round(count(*) *100.0 / sum(count(*)) over() ,2) as customer_pct
from customer_frequency
group by order_cnt
order by order_cnt asc;
