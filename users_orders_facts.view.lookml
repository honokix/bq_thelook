- view: users_orders_facts
  derived_table:
    sql: |
      SELECT orders.user_id AS user_id
        , COUNT(*) AS lifetime_orders
        , MIN(NULLIF(orders.created_at,0)) AS first_order
        , MAX(NULLIF(orders.created_at,0)) AS latest_order
        , DATEDIFF(MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) AS days_as_customer
        , DATEDIFF(CURDATE(),MAX(NULLIF(orders.created_at,0))) AS days_since_purchase
        , COUNT(DISTINCT CONCAT(MONTH(NULLIF(orders.created_at,0))),YEAR(NULLIF(orders.created_at,0))) AS number_of_distinct_months_with_orders
      FROM orders
      GROUP BY user_id
    indexes: [user_id]
    persist_for: 12 hours
#     sql_trigger_value: SELECT CURDATE()
  fields:

# DIMENSIONS #

  - dimension: user_id
    primary_key: true
    hidden: true

  - dimension: lifetime_orders
    type: number

  - dimension: lifetime_number_of_orders_tier
#     label: 'Lifetime Orders - Tier View'
    sql: |
      CASE
      WHEN ${lifetime_orders} < 3 THEN '1 to 2 fewer orders'
      WHEN ${lifetime_orders} < 6 THEN '3 to 5 orders'
      WHEN ${lifetime_orders} < 9 THEN '6 to 8 orders'
      ELSE '9 or more orders'
      END



  - dimension: repeat_customer
    type: yesno
    sql: ${lifetime_orders} > 1
  
  - dimension_group: first_order
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.first_order
    
  - dimension: latest_order
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.latest_order

  - dimension: days_as_customer
    type: int

  - dimension: days_as_customer_tiered
    type: tier
    style: integer
    tiers: [0,10,50,100,500]
    sql: ${days_as_customer}

  - dimension: days_since_purchase
    type: int

  - dimension: number_of_distinct_months_with_orders
    type: int
