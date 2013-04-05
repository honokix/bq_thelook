- view: inventory_items
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: cost
    type: number
    decimals: 2

  - name: sold
    type: time
    timeframes: [time, date, week, month]
    sql: $$.sold_at

  - name: created
    type: time
    timeframes: [time, date, week, month]
    sql: $$.created_at

  - name: product_id
    type: int
    sets:
      - ignore

  - name: id
    type: int

  # ----- Joins ------

  - join: products
    sql_on: inventory_items.product_id=products.id
    base_only: true

  # ----- Detail ------
  sets:
    detail: [
        id,
        products.item_name,
        products.id,
        # Counters for views that join 'inventory_items'
        order_items.count,
    ]

