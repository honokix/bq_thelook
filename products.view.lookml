- view: products
  fields:

# DIMENSIONS #

  - dimension: id
    type: int
    primary_key: true
    sql: ${TABLE}.id

  - dimension: brand.name   # brand name is a string in the db.
    sql: ${TABLE}.brand     #  we want a top level entity.
    html: |
      {{ linked_value }}
      <a href="/dashboards/thelook/2_brand_overview?brand={{ value | encode_uri }}" target="_new">
      <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>

  - dimension: category.name    # We want category to be a top level entity even though doesn't
    sql: ${TABLE}.category      #  have its own table
    html: |
      {{ linked_value }}
      <a href="/dashboards/thelook_redshift/3_category_lookup?category={{ value | encode_uri }}" target="_new">
      <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>

  - dimension: department.name
    sql: ${TABLE}.department

  - dimension: item_name
    sql: ${TABLE}.item_name

  - dimension: rank
    type: int
    sql: ${TABLE}.rank

  - dimension: retail_price
    type: number
    decimals: 2
    sql: ${TABLE}.retail_price

  - dimension: sku
    sql: ${TABLE}.sku

# MEASURES #

  - measure: count          # number of different products
    type: count
    detail: detail          # set to show when the count field is clicked

  - measure: brand_count    # number of different brands.
    type: count_distinct
    sql: ${TABLE}.brand     # the field in the db to distinctly count
    detail:                 # when the user clicks brand count
      - brand.name          # show the brand
      - sub_detail*         # a bunch of counts (see the set below)
      - -brand.count        # but don't show the brand count, because it will always be 1

  - measure: category_count #
    type: count_distinct
    sql: ${TABLE}.category
    detail:
      - category.name
      - sub_detail*
      - -category.count

  - measure: department_count
    type: count_distinct
    sql: ${TABLE}.department
    detail:
      - department.name
      - sub_detail*
      - -department.count

  - measure: brand_list
    type: list
    list_field: brand.name

  - measure: list
    type: list
    list_field: item_name

# SETS #

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
