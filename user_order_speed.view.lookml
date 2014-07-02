- view: order_sequence_number
  derived_table: 
    sql_trigger_value: SELECT CURDATE()
    indexes: [order_id]
    sql: |
      SELECT orders.id as order_id
      , (SELECT COUNT(*)
        FROM orders o
        WHERE o.id < orders.id
        AND o.user_id=orders.user_id) + 1 as sequence_number
      , DATEDIFF(orders.created_at, users.created_at) as order_days_since_reg
      , CASE WHEN DATEDIFF(orders.created_at, users.created_at) <= 91 THEN 1 ELSE 0 END as order_within_3m
      , CASE WHEN DATEDIFF(orders.created_at, users.created_at) <= 182 THEN 1 ELSE 0 END as order_within_6m
      , CASE WHEN DATEDIFF(orders.created_at, users.created_at) <= 365 THEN 1 ELSE 0 END as order_within_12m
      FROM orders
      JOIN users ON users.id = orders.user_id

- view: user_order_speed
  derived_table:
    sql_trigger_value: SELECT CURDATE()
    indexes: [user_id]
    sql: |
      SELECT orders.user_id AS user_id
        , users.created_at AS created
        , max(order_seq.sequence_number * order_seq.order_within_3m) as user_orders_within_3m
        , max(order_seq.sequence_number * order_seq.order_within_6m) as user_orders_within_6m
        , max(order_seq.sequence_number * order_seq.order_within_12m) as user_orders_within_12m
      FROM orders
      JOIN ${order_sequence_number.SQL_TABLE_NAME} as order_seq ON order_seq.order_id = orders.id
      JOIN users ON users.id = orders.user_id
      GROUP BY user_id

# - view: 6month_transition_rates
#   derived_table:
#     persist_for: 24 hours


  fields:
  - dimension: user_id
    sql: ${TABLE}.user_id

  - dimension: user_created
    type: time
    timeframes: [time, date, week, month, year]
    sql: ${TABLE}.user_created

  - dimension: user_orders_within_3m
    type: number
    sql: ${TABLE}.user_orders_within_3m

  - dimension: user_orders_within_6m
    type: number
    sql: ${TABLE}.user_orders_within_6m

  - dimension: user_orders_within_12m
    type: number
    sql: ${TABLE}.user_orders_within_12m

  - measure: users_count
    type: count
    sql: ${TABLE}.user_id
