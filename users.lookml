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
    tiers: [15,19,26,33]

  - dimension: city

  - dimension: country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: email

  - dimension: first_name

  - dimension: gender

  - dimension: id
    type: int

  - dimension: last_name
  
  - dimension: name
    sql: CONCAT($$.first_name,' ', $$.last_name)

  - name: history
    sql: $$.id
    html: |
      <a href=orders?fields=orders.detail*&limit=500&f[orders.completed_time]=10+years&f[users.id]=<%= value %>>Orders</a>
      | <a href=order_items?fields=order_items.detail*&f[orders.completed_time]=10+years&limit=500&f[users.id]=<%= value %>>Items</a>

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
  - name: lifetime_orders
    type: number

  - name: lifetime_number_of_orders_tier
    type: tier
    tiers: [0,1,2,3,5,10]
    sql: ${lifetime_orders}
    
  - name: repeat_order
    type: yesno
    sql: ${lifetime_orders} > 1
  
  - name: first_order
    type: time
    timeframes: [date, week, month]
    sql: $$.first_order

  - name: latest_order
    type: time
    timeframes: [date, week, month]
    sql: $$.latest_order

  - name: days_as_customer
    type: int
    
  - name: days_since_purchase
    type: int

  - name: number_of_distinct_months_with_orders
    type: int

