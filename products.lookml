- view: products
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: brand

  - dimension: category

  - dimension: department

  - dimension: id
    type: int

  - dimension: item_name
  
  - measure: list
    type: list
    list_field: item_name

  - dimension: rank
    type: int

  - dimension: retail_price
    type: number
    decimals: 2

  - dimension: sku


  # ----- Detail ------
  sets:
    detail:
      - id
      - item_name
      - brand
      - category
      - department
      - retail_price
        # Counters for views that join 'products'
      - inventory_items.count

