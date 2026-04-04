with order_sequence as (
  select 
    cd.customer_unique_id,
    od.order_id,
    od.order_approved_at,
    -- 依訂單時間排序編號
    row_number() over(partition by cd.customer_unique_id order by od.order_approved_at asc) as order_seq,
    -- 取得「前一筆」訂單的時間
    lag(od.order_approved_at) over(partition by cd.customer_unique_id order by od.order_approved_at asc) as prev_order_at
  from `project_name.2025_profile.olist_orders_dataset` as od
  join `project_name.2025_profile.olist_customers_dataset` as cd 
    on od.customer_id = cd.customer_id
  where od.order_status not in ('canceled','unavailable')
    and od.order_approved_at is not null
)

select 
  customer_unique_id,
  date(prev_order_at) as first_order_date,
  date(order_approved_at) as second_order_date,
  date_diff(date(order_approved_at), date(prev_order_at), day) as days_between_1st_2nd
from order_sequence
where order_seq = 2
order by days_between_1st_2nd desc;
