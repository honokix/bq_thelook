- view: inventory_items
  fields:

# DIMENSIONS #

  - dimension: id
    primary_key: true
    type: int

  - dimension: cost
    type: number
    decimals: 2
    sql: ${TABLE}.cost

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, day_of_week, hour_of_day]
    sql: ${TABLE}.created_at

  - dimension: product_id
    hidden: true
    type: int

  - dimension_group: sold
    type: time
    timeframes: [yesno, time, date, week, month]
    sql: ${TABLE}.sold_at

  - dimension: days_in_inventory
    type: int
    sql: DATEDIFF(${sold_date}, ${created_date})

  - dimension: days_in_inventory_tier
    type: tier
    sql: ${days_in_inventory}
    tiers: [0,5,10,20,40,80,160,360]

# MEASURES #

  - measure: count
    type: count
    drill_fields: detail

  - measure: sold_count
    type: count
    drill_fields: detail
    filters:
      sold: Yes

  - measure: percent_sold
    type: number
    decimals: 2
    sql: 100.0 * ${sold_count}/${count}

  - measure: total_cost
    type: sum
    decimals: 2
    sql: ${cost}

  - measure: average_cost
    type: average
    decimals: 2
    sql: ${cost}

  - measure: average_days_in_inventory
    type: average
    decimals: 2
    sql: ${days_in_inventory}

# SETS #

  sets:
    export:     # The fields we want to export to order items.
      - count
      - cost
      - created_date
      - days_in_inventory
      - days_in_inventory_tier

    detail:     # The fields we want to show when drilling.
      - id
      - sold_date
      - products.item_name
      - products.brand
      - products.category
      - products.department
      - cost
        # Counters for views that join 'inventory_items'
      - order_items.count