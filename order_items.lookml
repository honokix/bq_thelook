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


  # ----- Detail ------
  sets:
    detail:
      - id
      - inventory_items.id
      - orders.id

