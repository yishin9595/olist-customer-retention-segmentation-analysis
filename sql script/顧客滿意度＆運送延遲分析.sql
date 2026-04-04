with order_base as (
  select
    o.order_id as order_id,
    o.customer_id as customer_id,
    date_diff(o.order_delivered_customer_date,o.order_estimated_delivery_date,day) as delivery_delay,
    r.review_score as review_score
  from `project_name.2025_profile.olist_orders_dataset` as o
  join `project_name.2025_profile.olist_order_reviews_dataset` as r
    on o.order_id = r.order_id
  where o.order_delivered_customer_date is not null
),

geo_clean as (
  select
    geolocation_zip_code_prefix as geolocation_zip_code_prefix,
    any_value(geolocation_city) as city,
    any_value(geolocation_state) as state
  from `project_name.2025_profile.olist_geolocation_dataset`
  group by geolocation_zip_code_prefix
),

customer_geo as (
  select
    c.customer_id as customer_id,
    g.city as city,
    g.state as state
  from `project_name.2025_profile.olist_customers_dataset` as c
  join geo_clean as g
    on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
)

select
  cg.city as city,
  cg.state as state,
  count(*) as order_cnt,
  avg(ob.review_score) as avg_review_score,
  avg(ob.delivery_delay) as avg_delivery_delay,
  avg(case when ob.delivery_delay > 0 then 1 else 0 end) as late_delivery_rate

from order_base as ob
join customer_geo as cg
  on ob.customer_id = cg.customer_id

group by cg.city, cg.state
having count(*) > 30
order by avg_review_score asc
