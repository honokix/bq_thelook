- view: users
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: age
    type: int

  - dimension: age_tier
    type: tier
    sql: ${age}
    tiers: [0,10,20,30,40,50,60,70,80]

  - dimension: city

  - dimension: country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.created_at

  - dimension: email

  - dimension: first_name

  - dimension: gender

  - dimension: id
    type: int

  - dimension: last_name
  
  - dimension: name
    sql: CONCAT(${TABLE}.first_name,' ', ${TABLE}.last_name)

  - dimension: history
    sql: ${TABLE}.id
    html: |
      <a href=orders?fields=orders.detail*&f[users.id]=<%= value %>>Orders</a>
      | <a href=order_items?fields=order_items.detail*&f[users.id]=<%= value %>>Items</a>

  - dimension: state

  - dimension: zip
    type: int


  # ----- Detail ------
  sets:
    detail:
      - id
      - name
      - email
      - city
      - state
      - country
      - zip
      - gender
      - age
      - history
        # Counters for views that join 'users'
      - orders.count
      - order_items.count

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
  fields:
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
    
  - dimension: days_since_purchase
    type: int

  - dimension: number_of_distinct_months_with_orders
    type: int

