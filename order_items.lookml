- view: order_items
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: id
    type: int

  - dimension: inventory_item_id
    type: int
    sets:
      - ignore

  - dimension: order_id
    type: int
    sets:
      - ignore

  - dimension: sale_price
    type: number
    decimals: 2

  - name: profit
    type: number
    required_joins: [inventory_items]
    sql: ${TABLE}.sale_price - inventory_items.cost
    
  - name: profit_tier
    type: tier
    sql: ${profit}
    tiers: [0,10,25,50,150,300]
    
  - name: total_profit
    type: sum
    sql: ${profit}
    decimals: 2
    
  - name: total_sale_price
    type: sum
    sql: $$.sale_price
    decimals: 2
    
  - name: profit_margin
    type: percentage
    sql: ${total_profit}/${total_sale_price}
  
  - name: average_profit
    type: average
    sql: ${profit}
    decimals: 2


  # ----- Detail ------
  sets:
    detail:
      - orders.created_date
      - id
      - orders.id
      - users.name
      - users.history
      - products.item_name
      - products.brand
      - products.category
      - products.department
      - total_sale_price
      

