- view: users_first_order_facts

  derived_table:
    sql: |
      SELECT first_order_month, COUNT(*) as first_orders_count
      FROM
        (
        SELECT orders.user_id AS user_id
          , MIN(NULLIF(orders.created_at,0))) AS first_order_month
        FROM orders
        GROUP BY user_id
        ) first_orders
      GROUP BY first_order_date

  fields:
  - dimension: first_order
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.first_order_month

  - dimension: first_orders_count
    type: int
    sql: ${TABLE}.first_orders_count

  - measure: sum_first_orders_count
    type: sum
    sql: ${first_orders_count}
