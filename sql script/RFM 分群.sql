with order_payment as (
  select
    order_id,
    sum(payment_value) as order_value
  from `project_name.2025_profile.olist_order_payments_dataset`
  group by order_id
),

-- 訂單最後日期（計算 Recency 的基準點）
max_date as (
  select
    date(max(order_approved_at)) as max_dt
  from `project_name.2025_profile.olist_orders_dataset`
  where order_status not in ('canceled','unavailable')
    and order_approved_at is not null
),

rfm_base as (
  select
    cd.customer_unique_id,
    -- Recency
    date_diff(m.max_dt, date(max(od.order_approved_at)), day) as recency_days,
    -- Frequency
    count(distinct od.order_id) as frequency_count,
    -- Monetary
    round(sum(op.order_value), 2) as monetary_value
  from `project_name.2025_profile.olist_orders_dataset` as od
  join `project_name.2025_profile.olist_customers_dataset` as cd
    on od.customer_id = cd.customer_id
  join order_payment as op
    on od.order_id = op.order_id
  cross join max_date as m
  where od.order_status not in ('canceled','unavailable')
    and od.order_approved_at is not null
  group by cd.customer_unique_id, m.max_dt
),


rfm_score as (
  select
    *,
    -- R Score: 天數愈小越高分
    ntile(5) over (order by recency_days asc, customer_unique_id asc) as r_score,
    -- F Score
    case 
      when frequency_count = 1 then 1
      when frequency_count = 2 then 3
      when frequency_count >= 3 then 5
      else 1 
    end as f_score,
    -- M Score
    ntile(5) over (order by monetary_value asc, customer_unique_id asc) as m_score
  from rfm_base
),

rfm_segment as (
  select
    *,
    concat(cast(r_score as string), cast(f_score as string), cast(m_score as string)) as rfm_code,
    case
      when r_score >= 4 and f_score >= 3 then '重要價值客'
      when r_score >= 4 and f_score = 1 then '新客'
      when r_score <= 2 and (f_score >= 3 or m_score >= 4) then '高價值流失客'
      when r_score <= 2 and f_score = 1 then '已流失客戶'
      when r_score = 3 then '一般客戶'
      else '其他/沈睡中'
    end as customer_segment
  from rfm_score
)

select *
from rfm_segment
order by r_score desc, f_score desc, m_score desc;
