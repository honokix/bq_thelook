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
    decimals: 2


  # ----- Detail ------
  sets:
    detail:
      - id
      - inventory_items.id
      - orders.id

