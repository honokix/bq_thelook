- view: order_items
  fields:

# DIMENSIONS #

  - dimension: id
    type: number
    primary_key: true
    sql: ${TABLE}.id

  - dimension: inventory_item_id
    type: number
    sql: ${TABLE}.inventory_item_id
    hidden: true

  - dimension: return_date
    type: date
    sql: ${TABLE}.returned_at

  - dimension: returned
    type: yesno
    sql: ${TABLE}.returned_at IS NOT NULL

  - dimension: order_id
    type: number
    sql: ${TABLE}.order_id
    hidden: true

  - dimension: sale_price
    description: The sale price reflects the price that the item was sold at.
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.sale_price

  - dimension: gross_margin
    type: number
    value_format_name: decimal_2
    sql: ${sale_price} - ${inventory_items.cost}

  - dimension: item_gross_margin_percentage
    type: number
    sql: 100.0 * ${gross_margin}/NULLIF(${sale_price}, 0)

  - dimension: item_gross_margin_percentage_tier
    type: tier
    sql: ${item_gross_margin_percentage}
    tiers: [0,10,20,30,40,50,60,70,80,90]

# MEASURES #

  - measure: count
    type: count
    drill_fields: detail

  - measure: total_gross_margin
    type: sum
    sql: ${gross_margin}
    value_format: '$#,##0.00'

  - measure: total_sale_price
    type: sum
    sql: ${sale_price}
    value_format: '$#,##0.00'

  
  - measure: average_sale_price
    type: average
    sql: ${sale_price}
    value_format: '$#,##0.00'

  - measure: average_gross_margin
    type: average
    sql: ${gross_margin}
    value_format_name: decimal_2

#   - measure: total_sale_price_per_first_order_user_daily
#     type: sum
#     sql: ${sale_price} / ${users_first_order_facts_daily.first_orders_count_daily}
#     value_format_name: decimal_2
#     html: |
#       ${{ rendered_value }}
# 
#   - measure: total_sale_price_per_first_order_user_weekly
#     type: sum
#     sql: ${sale_price} / ${users_first_order_facts_weekly.first_orders_count_weekly}
#     value_format_name: decimal_2
#     html: |
#       ${{ rendered_value }}
# 
#   - measure: total_sale_price_per_first_order_user_monthly
#     type: sum
#     sql: ${sale_price} / ${users_first_order_facts_monthly.first_orders_count_monthly}
#     value_format_name: decimal_2
#     html: |
#       ${{ rendered_value }}

#   - measure: gross_margin_percentage
#     type: number
#     sql: 100.0 * ${total_gross_margin}/${total_sale_price}    # postgres does integer division by default, so multiply by 100.0
#     value_format_name: decimal_2                                               #  to force real numbers.


# SETS #

  sets:
    detail:
      - orders.created_date
      - id
      - orders.id
      - users.name
      - users.history
      - products.item_name
      - brand.name
      - category.name
      - department.name
      - total_sale_price