- view: products
  fields:

  - measure: count          # number of different products
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail          # set to show when the count field is clicked

  - dimension: brand        # brand name is a string in the db.
  
  - measure: brand_count    # number of different brands.
    type: count_distinct
    sql: ${TABLE}.brand     # the field in the db to distinctly count
    detail:                 # when the user clicks brand count
      - brand               # show the brand
      - sub_detail*         # a bunch of counts (see the set below)
      - -brand_count        # but don't show the brand count, because it will always be 1
      
  - dimension: category

  - measure: category_count
    type: count_distinct
    sql: ${TABLE}.category
    detail: 
      - category
      - sub_detail*
      - -category_count

  - dimension: department

  - measure: department_count
    type: count_distinct
    sql: ${TABLE}.department
    detail: 
      - department
      - sub_detail*
      - -department_count

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
      - customers.count
      - orders.count
      - order_items.count
      - inventory_items.count
  
    sub_detail:
      - category_count
      - brand_count
      - department_count
      - count
      - customers.count
      - orders.count
      - order_items.count
      - inventory_items.count
      - products.count

