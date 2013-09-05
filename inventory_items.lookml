- view: inventory_items
  fields:

  - dimension: id
    primary_key: true
    type: int

  - measure: count
    type: count
    detail: detail

  - measure: sold_count
    type: count
    detail: detail
    filters:
      sold: Yes

  - measure: percent_sold
    type: number
    decimals: 2
    sql: 100.0 * ${sold_count}/${count}

  - dimension: cost
    type: number
    decimals: 2
    sql: ${TABLE}.cost
    
  - measure: total_cost
    type: sum
    sql: ${cost}

  - measure: average_cost
    type: average
    sql: ${cost}

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
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
    sql: DATEDIFF(${sold_date},${created_date})

  - dimension: days_in_inventory_tier
    type: tier
    sql: ${days_in_inventory}
    tiers: [0,5,10,20,40,80,160,360]


  # ----- Detail ------
  sets:
    # The fields we want to export to order items.
    export:
      - count
      - cost
      - created_date
      - days_in_inventory
      - days_in_inventory_tier
      
    # fields we want to sho when drilling.
    detail:
      - id
      - sold_date
      - products.item_name
      - products.brand
      - products.category
      - products.department
      - cost
        # Counters for views that join 'inventory_items'
      - order_items.count

