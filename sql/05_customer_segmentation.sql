with order_payment as (
  select
    order_id,
    sum(payment_value) as order_value
  from `project_name.Brazilian_ECommerce_Olist.olist_order_payments_dataset`
  group by order_id
),

customer_order_sumarry as (

  select 
    customer.customer_unique_id,
    count(distinct orders.order_id) as order_cnt,
    DATE(min(orders.order_approved_at)) as first_order_date,
    DATE(max(orders.order_approved_at)) as last_order_date,
    sum(order_value) as total_order_value
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset` as orders
  join `project_name.Brazilian_ECommerce_Olist.olist_customers_dataset` as customer
    on orders.customer_id = customer.customer_id
  join order_payment as op
    on op.order_id = orders.order_id
  where orders.order_status not in  ('canceled', 'unavailable')
    and orders.order_approved_at IS NOT NULL
  group by customer.customer_unique_id
),

max_date as (
  select
    date(max(order_approved_at)) as max_date
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset`
  where order_status not in  ('canceled', 'unavailable')
    and order_approved_at IS NOT NULL
)

select
  case 
    when date_diff(max_date.max_date , first_order_date , day) <= 30 and order_cnt = 1 then '新客'
    when date_diff(max_date.max_date , first_order_date , day) > 30 and order_cnt = 1 then '未回購顧客'
    when date_diff(max_date.max_date , last_order_date , day) <= 180 and order_cnt >=2 then '活躍回購客'
    when date_diff(max_date.max_date , last_order_date , day) > 180 and order_cnt >= 2 then '非活躍回購客'
  end as customer_segment,
  count(*) as customers_cnt,
  round(count(*) *100.0 / sum(count(*)) over() ,2 ) as customer_pct,
  round(sum(total_order_value),2) as total_revenue,
  round(sum(total_order_value) *100.0 / sum(sum(total_order_value)) over() ,2 ) as revenue_pct,
  round(avg(total_order_value),2) as avg_spend_per_customer
from customer_order_sumarry
cross join max_date
group by customer_segment
order by total_revenue desc;
