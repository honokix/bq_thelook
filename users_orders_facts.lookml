- view: users_orders_facts
  derived_table:
    sql: |
      SELECT
        orders.user_id as user_id
        , COUNT(*) as lifetime_orders
        , MIN(NULLIF(orders.created_at,0)) as first_order
        , MAX(NULLIF(orders.created_at,0)) as latest_order
        , DATEDIFF(MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) as days_as_customer
        , DATEDIFF(CURDATE(),MAX(NULLIF(orders.created_at,0))) as days_since_purchase
        , COUNT(DISTINCT MONTH(NULLIF(orders.created_at,0))) as number_of_distinct_months_with_orders
      FROM orders
      GROUP BY user_id
    indexes: [user_id]
    persist_for: 12 hours

  fields:
  - dimension: user_id
    primary_key: true
    hidden: true
  
  - dimension: lifetime_orders
    type: number

  - dimension: lifetime_number_of_orders_tier
    type: tier
    tiers: [0,1,2,3,5,10]
    sql: ${lifetime_orders}
    
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
    tiers: [0,1,2,3,4,5,6,7,30,60,90,180]
    sql: ${days_as_customer}
    
  - dimension: days_since_purchase
    type: int

  - dimension: number_of_distinct_months_with_orders
    type: int