- view: orders
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: user_id
    type: int
    sets:
      - ignore

  - name: created
    type: time
    timeframes: [time, date, week, month]
    sql: $$.created_at

  - name: id
    type: int

  - name: total_number_of_items
    type: int
    sql: |
      (SELECT COUNT(order_items.id) FROM order_items WHERE order_items.order_id = orders.id)

  - name: total_amount_of_order_usd
    type: number
    decimals: 2
    sql: |
      (SELECT SUM(order_items.sale_price) FROM order_items WHERE order_items.order_id = orders.id)

  - name: total_amount_of_order_usd_tier
    type: tier
    sql: ${total_amount_of_order_usd}
    tiers: [0,10,50,150,500,1000]

  - name: order_items_list
    sql: |
      (
        SELECT GROUP_CONCAT(products.item_name) 
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        LEFT JOIN products ON inventory_items.product_id = products.id
        WHERE order_items.order_id = orders.id
      )

  - name: average_total_amount_of_order_usd
    type: avg
    sql: ${total_amount_of_order_usd}

  - name: total_cost_of_order
    type: number
    decimals: 2
    sql: |
      (
        SELECT SUM(inventory_items.cost)
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        WHERE order_items.order_id = orders.id
      )
      
  - name: order_profit
    type: number
    decimals: 2
    sql: ${total_amount_of_order_usd} - ${total_cost_of_order}
  
  - name: sum_order_profit
    type: sum
    sql: ${order_profit}
    
  - name: average_order_profit
    type: average
    sql: ${order_profit}
  
  # ----- Joins ------

  - join: users
    sql_on: orders.user_id=users.id
    base_only: true
    

  # ----- Detail ------
  sets:
    detail: [
        id,
        users.last_name,
        users.first_name,
        users.id,
        # Counters for views that join 'orders'
        order_items.count,
    ]

