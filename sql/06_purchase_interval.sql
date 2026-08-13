with customer_order as (
  select 
    customer.customer_unique_id,
    DATE(orders.order_approved_at) as order_date,
    row_number() over(partition by customer.customer_unique_id order by date(orders.order_approved_at) asc) as order_rank,
    lag(DATE(orders.order_approved_at)) over(partition by customer.customer_unique_id order by orders.order_approved_at asc) as previous_order_date
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset` as orders
  join `project_name.Brazilian_ECommerce_Olist.olist_customers_dataset` as customer
    on orders.customer_id = customer.customer_id
  where orders.order_status not in  ('canceled', 'unavailable')
    and orders.order_approved_at IS NOT NULL
),


purchase_interval as (
  select
    customer_unique_id,
    order_rank,
    date_diff(order_date , previous_order_date , day) as interval_days
  from customer_order
  where order_rank >= 2 
    and previous_order_date is not null
)

select
  case 
    when interval_days <= 30 then '0-30 days'
    when interval_days <= 60 then '31-60 days'
    when interval_days <= 90 then '61-90 days'
    when interval_days <= 180 then '91-180 days'
    else '180+ days'
  end as purchase_interval_days,
  count(*) as orders_cnt,
  round(count(*) *100.0 / sum(count(*)) over() ,2 ) as order_pct
from purchase_interval
group by purchase_interval_days
order by min(interval_days);
