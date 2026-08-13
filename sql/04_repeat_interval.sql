with customer_order as (
  select 
    customer.customer_unique_id,
    DATE(orders.order_approved_at) as order_date,
    row_number() over(partition by customer.customer_unique_id order by date(orders.order_approved_at) asc) as order_rank
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset` as orders
  join `project_name.Brazilian_ECommerce_Olist.olist_customers_dataset` as customer
    on orders.customer_id = customer.customer_id
  where orders.order_status not in  ('canceled', 'unavailable')
    and orders.order_approved_at IS NOT NULL
),

customer_repeat as (
  select
    customer_unique_id,
    max(case when order_rank = 1 then order_date end) as first_order_date,
    max(case when order_rank = 2 then order_date end) as second_order_date
  from customer_order
  group by customer_unique_id
),

repeat_interval as (
  select
    customer_unique_id,
    date_diff(second_order_date , first_order_date , day ) as days_to_second_order
  from customer_repeat
  where second_order_date is not null
)

select
  case 
    when days_to_second_order <= 30 then '0-30 days'
    when days_to_second_order <= 60 then '31-60 days'
    when days_to_second_order <= 90 then '61-90 days'
    when days_to_second_order <= 180 then '91-180 days'
    else '180+ days'
  end as repeat_interval_day,
  count(*) as customer_cnt,
  round(count(*) *100.0 / sum(count(*)) over() ,2 ) as customer_pct
from repeat_interval
group by repeat_interval_day
order by min(days_to_second_order)
