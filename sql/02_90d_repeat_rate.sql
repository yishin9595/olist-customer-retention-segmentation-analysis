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

max_date as (
  select
    date(max(order_approved_at)) as max_date
  from `project_name.Brazilian_ECommerce_Olist.olist_orders_dataset`
  where order_status not in  ('canceled', 'unavailable')
    and order_approved_at IS NOT NULL
)

select
  date_trunc(first_order_date, month) as first_order_month,
  sum(case when date_diff(second_order_date, first_order_date, day) <= 90 then 1 else 0 end) as repeat_90d_cnt,
  round(sum(case when date_diff(second_order_date, first_order_date, day) <= 90 then 1 else 0 end) * 100.0 / count(*) ,2 ) as repeat_90d_rate
from customer_repeat
cross join max_date
where first_order_date <= date_sub(max_date.max_date , interval 90 day) -- 篩去沒有 90 天以上觀察期的資料
group by date_trunc(first_order_date, month)
order by first_order_month asc;
