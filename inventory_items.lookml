- view: inventory_items
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: cost
    type: number

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: id
    type: int

  - dimension: product_id
    type: int
    sets:
      - ignore

  - dimension_group: sold
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.sold_at


  # ----- Detail ------
  sets:
    detail:
      - id
      - products.item_name
        # Counters for views that join 'inventory_items'
      - order_items.count

