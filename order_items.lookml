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

  - dimension: item_gross_margin
    type: number
    sql: (${sale_price} - ${inventory_items.cost})

  - dimension: item_gross_margin_percentage
    type: number
    sql: 100.0 * ${item_gross_margin}/${sale_price}

  - dimension: item_gross_margin_percentage_tier
    type: tier
    sql: ${item_gross_margin_percentage}
    tiers: [0,10,20,30,40,50,60,70,80,90]

  - measure: total_gross_margin
    type: sum
    sql: ${item_gross_margin}
    decimals: 2
    
  - measure: total_sale_price
    type: sum
    sql: ${sale_price}
    decimals: 2
    html: |
      $<%= rendered_value %>

  - measure: average_sale_price
    type: avg
    sql: ${sale_price}
    decimals: 2
    html: |
      $<%= rendered_value %>

  - measure: gross_margin_percentage
    type: number
    sql: 100.0 * ${total_gross_margin}/${total_sale_price}    # postgres does integer division by default multiply by 100.0
    decimals: 2                                               #  to force real numbers.
    
  - measure: average_gross_margin
    type: average
    sql: ${item_gross_margin}
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
