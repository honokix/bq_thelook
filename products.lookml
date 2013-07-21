- view: products
  fields:

  - measure: count          # number of different products
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail          # set to show when the count field is clicked

  - dimension: brand.name   # brand name is a string in the db.
    sql: ${TABLE}.brand     #  we want a top level entity.
  
  - measure: brand.count    # number of different brands.
    type: count_distinct
    sql: ${TABLE}.brand     # the field in the db to distinctly count
    detail:                 # when the user clicks brand count
      - brand.name          # show the brand
      - sub_detail*         # a bunch of counts (see the set below)
      - -brand.count        # but don't show the brand count, because it will always be 1
      
  - dimension: category.name    # We want category to be a top level entity even though doesn't
    sql: ${TABLE}.category      #  have its own table

  - measure: category.count #
    type: count_distinct
    sql: ${TABLE}.category
    detail: 
      - category.name
      - sub_detail*
      - -category.count

  - dimension: department.name
    sql: ${TABLE}.department

  - measure: department.count
    type: count_distinct
    sql: ${TABLE}.department
    detail: 
      - department.name
      - sub_detail*
      - -department.count

  - dimension: id
    type: int

  - dimension: item_name

  - measure: brand.list
    type: list
    list_field: brand.name

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
      - brand.name
      - category.name
      - department.name
      - retail_price
        # Counters for views that join 'products'
      - customers.count
      - orders.count
      - order_items.count
      - inventory_items.count
  
    sub_detail:
      - category.count
      - brand.count
      - department.count
      - count
      - customers.count
      - orders.count
      - order_items.count
      - inventory_items.count
      - products.count

