with rfm as (
  select
    cd.customer_unique_id,
    date_diff('2025-12-18',date(max(od.order_approved_at)),day) as recency,
    count(distinct od.order_id) as frequency,
    round(sum(op.payment_value),2) as monetary
  from `lisa-project-383407.2025_profile.olist_orders_dataset` as od
  inner join  `lisa-project-383407.2025_profile.olist_customers_dataset` as cd
    on od.customer_id = cd.customer_id
  inner join `lisa-project-383407.2025_profile.olist_order_payments_dataset` as op
    on od.order_id = op.order_id
  where order_status not in ('canceled' , 'unavailable')
    and od.order_approved_at is not null
  group by cd.customer_unique_id
),

rfm_score as (
  select *, 
    ntile(5) over(order by recency desc) as r_score,
    ntile(5) over(order by frequency) as f_score,
    ntile(5) over(order by monetary) as m_score
  from rfm
),

category as (
  select *,
    concat(r_score , f_score , m_score) as rfm_segments,
    case
      when r_score = 5 and f_score = 5 and m_score = 5 then 'VIP'
      when r_score <= 2 and m_score >= 4 then '高消費沉睡'
      when r_score = 5 and f_score = 1 then '新客'
      when r_score >= 4 and f_score >= 4 then '忠誠客'
      when r_score <= 2 and f_score <= 2 and m_score <= 2 THEN '流失客'
    else '一般客戶'
  end as customer_segment
  from rfm_score
)

select
  customer_segment,
  count(distinct customer_unique_id) as members,
  sum(monetary) as total_monetary,
  avg(monetary) as avg_monetary
from category
group by customer_segment;
