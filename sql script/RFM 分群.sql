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
    -- R：越近越高
    ntile(5) over (order by recency_days desc) as r_score,

    -- F：越多越高
    ntile(5) over (order by frequency_count asc) as f_score,

    -- M：越高越高
    ntile(5) over (order by monetary_value asc) as m_score

  from rfm_base
),

rfm_segment as (
  select
    *,
    concat(r_score, f_score, m_score) as rfm_code,
    case
      when r_score >= 4 and f_score >= 4 and m_score >= 4 then 'VIP'
      when r_score >= 4 and f_score >= 3 then 'Loyal Customers'
      when r_score >= 4 and f_score <= 2 then 'New Customers'
      when r_score <= 2 and (f_score >= 4 or m_score >= 4) then 'At Risk'
      when r_score <= 2 and f_score <= 2 then 'Churned'
      else 'Others'
    end as customer_segment
  from rfm_score
)

select *
from rfm_segment
order by r_score desc, f_score desc, m_score desc;
