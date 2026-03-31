with base as (
  select
    c.customer_unique_id,
    p.product_category_name,
    o.order_id
  from `lisa-project-383407.2025_profile.olist_orders_dataset` as  o
  join `lisa-project-383407.2025_profile.olist_customers_dataset` as c
    on o.customer_id = c.customer_id
  join `lisa-project-383407.2025_profile.olist_order_items_dataset` as oi
    on o.order_id = oi.order_id
  join `lisa-project-383407.2025_profile.olist_products_dataset` as p
    on oi.product_id = p.product_id
  where o.order_status not in ('canceled','unavailable')
),

customer_category_orders as (
  select
    customer_unique_id,
    product_category_name,
    count(distinct order_id) as order_cnt
  from base
  group by 1,2
),

agg as (
  select  
    product_category_name,
    count(distinct customer_unique_id) as n,
    count(distinct case when order_cnt >= 2 then customer_unique_id end) as repeat_customers
  from customer_category_orders
  group by product_category_name
)

select
  product_category_name,
  n,
  repeat_customers,
  round(safe_divide(repeat_customers, n), 2) as repurchase_rate,
  sqrt(safe_divide(safe_divide(repeat_customers, n) * (1 - safe_divide(repeat_customers, n)), n) ) as se 
  -- 計算標準誤，大於 1% 不穩定，小於 1% 比較穩定
from agg
