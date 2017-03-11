- view: products
  fields:

# DIMENSIONS #

  - dimension: id
    type: number
    primary_key: true
    sql: ${TABLE}.id

  - dimension: brand_name   # brand name is a string in the db
    alias: [brand.name]
    sql: ${TABLE}.brand     #  we want a top level entity.
    html: |
      {{ linked_value }}
      <a href="/dashboards/thelook/2_brand_overview?brand={{ value | encode_uri }}">
      <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>
 
  - dimension: brand_name_two   # brand name is a string in the db
    alias: [brand.name]
    sql: ${TABLE}.brand     #  we want a top level entity.
    html: |
      {{ value }}

  - dimension: category_name    # We want category to be a top level entity even though doesn't
    alias: [category.name]
    sql: ${TABLE}.category      #  have its own table
    html: |
      {{ linked_value }}
      <a href="/dashboards/thelook_redshift/3_category_lookup?category={{ value | encode_uri }}" target="_new">
      <img src="/images/qr-graph-line@2x.png" height=20 width=20></a>
#       <img src="http://s1.huffpost.com/images/v/linkout_image.png" width=8 height=8></a>

  - dimension: department_name
    alias: [department.name]
    sql: ${TABLE}.department

  - dimension: item_name
    sql: ${TABLE}.item_name

  - dimension: rank
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.rank

  - dimension: retail_price
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.retail_price
    
  - dimension: retail_price_tiered
    type: tier
    sql: ${retail_price}
    tiers: [0,100,200,300,400,500,600,700,800,900,999]

  - dimension: sku
    sql: ${TABLE}.sku
 
  # these next two dimensions dyanmically builds an image file based on the product_id fior image dashboard
  - dimension: image_file
    sql: (concat('http://www.looker.com/_content/docs/99-hidden/images/image_',${id},'.png'))

  - dimension: product_image
    sql: ${image_file}
    html: <img src="{{ value }}" width="100" height="100"/>
    
# MEASURES #

  - measure: count          # number of different products
    type: count
    drill_fields: detail          # set to show when the count field is clicked

  - measure: brand_count    # number of different brands.
    alias: [brand.count]
    type: count_distinct
    sql: ${TABLE}.brand     # the field in the db to distinctly count
    drill_fields:                 # when the user clicks brand count
      - brand_name          # show the brand
      - sub_detail*         # a bunch of counts (see the set below)
      - -brand_count        # but don't show the brand count, because it will always be 1

  - measure: category_count #
    alias: [category.count]
    type: count_distinct
    sql: ${TABLE}.category
    drill_fields:
      - category_name
      - sub_detail*
      - -category_count

  - measure: department_count
    alias: [department.count]
    type: count_distinct
    sql: ${TABLE}.department
    drill_fields:
      - department_name
      - sub_detail*
      - -department_count

  - measure: brand_list
    type: list
    list_field: brand_name

  - measure: list
    type: list
    list_field: item_name

# SETS #

  sets:
    detail:
      - id
      - item_name
      - brand_name
      - category_name
      - department_name
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
