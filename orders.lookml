- view: orders
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: total_amount_of_order_usd
    type: number
    decimals: 2
    sql: |
      (SELECT SUM(order_items.sale_price) FROM order_items WHERE order_items.order_id = orders.id)

  - dimension: total_cost_of_order
    type: number
    decimals: 2
    sql: |
      (
        SELECT SUM(inventory_items.cost)
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        WHERE order_items.order_id = orders.id
      )

  - dimension: total_number_of_items
    type: int
    sql: |
      (SELECT COUNT(order_items.id) FROM order_items WHERE order_items.order_id = orders.id)

  - dimension: order_profit
    type: number
    decimals: 2
    sql: ${total_amount_of_order_usd} - ${total_cost_of_order}
  
  - measure: order_profit_total
    type: sum
    sql: ${order_profit}

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: id
    type: int

  - dimension: user_id
    type: int
    sets:
      - ignore


  # ----- Detail ------
  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id
        # Counters for views that join 'orders'
      - order_items.count

