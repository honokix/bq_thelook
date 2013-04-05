- view: order_items
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: sale_price
    type: number
    decimals: 2

  - name: inventory_item_id
    type: int
    sets:
      - ignore

  - name: order_id
    type: int
    sets:
      - ignore

  - name: id
    type: int
    
  - name: profit
    type: number
    required_joins: [inventory_items]
    sql: $$.sale_price - inventory_items.cost
    
  - name: profit_tier
    type: tier
    sql: ${profit}
    tiers: [0,10,25,50,150,300]
    
  - name: profit_sum
    type: sum
    sql: ${profit}
    
  - name: sale_price_sum
    type: sum
    sql: $$.sale_price
    
  - name: profit_margin
    type: percentage
    sql: ${profit_sum}/${sale_price_sum}
  
  - name: average_profit
    type: average
    sql: ${profit}

  # ----- Joins ------

  - join: inventory_items
    sql_on: order_items.inventory_item_id=inventory_items.id

  - join: orders
    sql_on: order_items.order_id=orders.id

  - join: products
    sql_on: inventory_items.product_id=products.id
    required_joins: [inventory_items]
    base_only: true

  - join: users
    sql_on: orders.user_id=users.id
    required_joins: [orders]
    base_only: true

  # ----- Detail ------
  sets:
    detail: [
        id,
        inventory_items.id,
        orders.id,
    ]

