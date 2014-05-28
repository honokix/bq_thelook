- view: users_orders_facts
  derived_table:
    sql: |
      SELECT new_orders.user_id AS user_id
        , COUNT(*) AS lifetime_new_orders
        , MIN(NULLIF(new_orders.created_at,0)) AS first_order
        , MAX(NULLIF(new_orders.created_at,0)) AS latest_order
        , DATEDIFF(MAX(NULLIF(new_orders.created_at,0)),MIN(NULLIF(new_orders.created_at,0))) AS days_as_customer
        , DATEDIFF(CURDATE(),MAX(NULLIF(new_orders.created_at,0))) AS days_since_purchase
        , COUNT(DISTINCT MONTH(NULLIF(new_orders.created_at,0))) AS number_of_distinct_months_with_new_orders
      FROM new_orders
      GROUP BY user_id
    indexes: [user_id]
    persist_for: 12 hours
#     sql_trigger_value: SELECT CURDATE()
  fields:
  
# DIMENSIONS #

  - dimension: user_id
    primary_key: true
    hidden: true
  
  - dimension: lifetime_new_orders
    type: number
    
  - dimension: lifetime_number_of_new_orders_tier
    type: tier
    tiers: [0,1,2,3,5,10]
    sql: ${lifetime_new_orders}
    
  - dimension: repeat_customer
    type: yesno
    sql: ${lifetime_new_orders} > 1
  
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
    tiers: [0,10,50,100,500]
    sql: ${days_as_customer}
    
  - dimension: days_since_purchase
    type: int

  - dimension: number_of_distinct_months_with_new_orders
    type: int