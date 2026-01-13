with rev as (
  select
    cd.business_segment,
    count(o.order_id) as order_counts,
    sum(oi.price + oi.freight_value) as revenue
  from `lisa-project-383407.2025_profile.olist_closed_deals_dataset` as cd
  join `lisa-project-383407.2025_profile.olist_order_items_dataset` as oi
    on cd.seller_id = oi.seller_id
  join `lisa-project-383407.2025_profile.olist_orders_dataset` as o
    on oi.order_id = o.order_id
  where o.order_status not in ('canceled', 'unavailable')
    and o.order_estimated_delivery_date is not null
    and extract(year from o.order_estimated_delivery_date) = 2018
  group by 1
),
tot as (
  select 
    sum(revenue) as total_revenue 
  from rev
)
select
  r.business_segment,
  r.order_counts,
  round(r.revenue, 2) as revenue_2018,
  round(safe_divide(r.revenue, order_counts), 4) as AOV,
  round(safe_divide(r.revenue, t.total_revenue), 4) as revenue_share
from rev as r
cross join tot as t
order by revenue_2018 desc;