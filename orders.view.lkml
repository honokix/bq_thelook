# This view is referencing the 'orders' table in the database within the MODELS '- connection: thelook'
view: orders {
  # DIMENSIONS - Are used for grouping and filtering. #
  # When a view is joined to a base view all dimensions become available in that base view #

  dimension: id {
    label: "woot"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    description: "date fields"
    timeframes: [
      time,
      date,
      week,
      month,
      month_num,
      year,
      day_of_week_index,
      hour_of_day,
      minute5,
      day_of_month
    ]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
  }

  dimension_group: created_doy {
    type: time
    description: "date fields"
    timeframes: [day_of_year]
    sql: ${TABLE}.created_at ;;
    convert_tz: no
    html: {{created_month_num._rendered_value}}-{{created_day_of_month._rendered_value}}
      ;;
  }

  measure: max_date {
    type: max
    sql: ${TABLE}.created_at ;;
  }

  measure: earliest_order_date {
    type: date
    sql: MIN(${TABLE}.created_at) ;;
  }

  measure: latest_order_date {
    type: date
    sql: MAX(${TABLE}.created_at) ;;
  }

  filter: time_period_filter {}
  filter: offset_days_filter {}

  dimension: time_period {
    description: "date fields"
    type: number
    sql: {% parameter time_period_filter %}
      ;;
  }

  dimension: offset_days {
    type: number
    sql: {% parameter offset_days_filter %}
      ;;
  }

  dimension: status {
    description: "date fieldssadfasdfasdfasdfas sdf asdf asdf asdf sad fas dfasdf df asdfasdfasdfasdf"
    sql: ${TABLE}.status ;;
  }

  measure: min_status {
    type: string
    description: "date fieldssadfasdfasdfasdfasdf asdfasdfasdfasdf"
    sql: MIN(${status}) ;;
  }

  dimension: total_amount_of_order_usd {
    type: number
    description: "date fieldssadfasdfasdfasdfasdf asdfasdfasdfasdf"
    value_format_name: decimal_2
    sql: (SELECT SUM(order_items.sale_price)
      FROM order_items
      WHERE order_items.order_id = orders.id)
       ;;
  }

  dimension: total_amount_of_order_usd_tier {
    type: tier
    sql: ${total_amount_of_order_usd} ;;
    tiers: [
      0,
      10,
      50,
      150,
      500,
      750,
      1000,
      2000,
      3000
    ]
  }

  dimension: order_items_list {
    sql: (SELECT GROUP_CONCAT(products.item_name)
      FROM order_items
      LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN products ON inventory_items.product_id = products.id
      WHERE order_items.order_id = orders.id)
       ;;
  }

  dimension: total_cost_of_order {
    type: number
    value_format_name: decimal_2
    sql: (SELECT SUM(inventory_items.cost)
      FROM order_items
      LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
      WHERE order_items.order_id = orders.id)
       ;;
  }

  dimension: total_number_of_items {
    type: number
    value_format_name: decimal_0
    sql: (SELECT COUNT(order_items.id)
      FROM order_items
      WHERE order_items.order_id = orders.id)
       ;;
  }

  dimension: order_profit {
    type: number
    value_format_name: decimal_2
    sql: ${total_amount_of_order_usd} - ${total_cost_of_order} ;;
    html: ${{ rendered_value }}
      ;;
  }

  measure: profit_per_user {
    type: number
    value_format_name: decimal_2
    sql: 1.0 * ${order_profit}/NULLIF(${users.count},0) ;;
    html: ${{ rendered_value }}
      ;;
  }

  dimension: order_sequence_number {
    type: number
    sql: (SELECT COUNT(*)
      FROM orders o
      WHERE o.id < ${TABLE}.id
      AND o.user_id=${TABLE}.user_id) + 1
       ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${order_sequence_number} = 1 ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
  }

  dimension: month_text {
    case: {
      when: {
        sql: ${created_month_num} = 9 ;;
        label: "September"
      }

      when: {
        sql: ${created_month_num} = 10 ;;
        label: "October"
      }

      when: {
        sql: ${created_month_num} = 11 ;;
        label: "November"
      }

      when: {
        sql: ${created_month_num} = 12 ;;
        label: "December"
      }

      else: ""
    }
  }

  dimension: user_order_month_normalized {
    type: number
    sql: 12* (YEAR(${TABLE}.created_at)  - YEAR(${users.created_date}))  + MONTH(${TABLE}.created_at) - MONTH(${users.created_date}) ;;
  }

  dimension: is_same_dow_as_today {
    type: yesno
    #     hidden: true
    sql: DAYOFWEEK(${TABLE}.created_at) = DAYOFWEEK(current_timestamp) ;;
  }

  dimension: months_since_user_created_sharp {
    type: number
    sql: YEAR(${created_date})*12
      + MONTH(${created_date})
      - YEAR(${users.created_date})*12
      - MONTH(${users.created_date})
       ;;
  }

  dimension: months_since_users_first_order_sharp {
    type: number
    sql: YEAR(${created_date})*12
      + MONTH(${created_date})
      - YEAR(${users_orders_facts.first_order_date})*12
      - MONTH(${users_orders_facts.first_order_date})
       ;;
  }

  dimension: months_since_users_first_order_smooth {
    type: number
    value_format_name: decimal_0
    sql: FLOOR(DATEDIFF(${created_date}, ${users_orders_facts.first_order_date})/30.416667) ;;
  }

  # MEASURES - Measure fields calculate an aggregate value across a set of values for a dimension.
  # Measures will only appear for base views based on this view, or if the join of this view to a base view is one_to_one#

  measure: sum_total_amount_of_order_usd {
    type: sum
    sql: ${total_amount_of_order_usd} ;;
    value_format_name: usd
  }

  measure: average_total_amount_of_order_usd {
    type: average
    sql: ${total_amount_of_order_usd} ;;
    value_format_name: usd
  }

  measure: this_week_count {
    type: count_distinct
    sql: ${TABLE}.id ;;
    drill_fields: [detail*]

    filters: {
      field: created_date
      value: "7 days"
    }
  }

  measure: this_last_14_days_count {
    type: count_distinct
    sql: ${TABLE}.id ;;
    drill_fields: [detail*]

    filters: {
      field: created_date
      value: "14 days"
    }
  }

  measure: this_last_30_days_count {
    type: count_distinct
    sql: ${TABLE}.id ;;
    drill_fields: [detail*]

    filters: {
      field: created_date
      value: "30 days"
    }
  }

  measure: count {
    type: count_distinct
    sql: ${TABLE}.id ;;
  }

  measure: count_not_first {
    type: count_distinct
    sql: ${TABLE}.id ;;

    filters: {
      field: users.gender
      value: "m"
    }
  }

  measure: order_percent_change {
    type: percent_of_previous
    sql: ${count} ;;
  }

  measure: count_percent_of_total {
    label: "Count (Percent of Total)"
    type: percent_of_total
    drill_fields: [detail*]
    value_format_name: decimal_1
    sql: ${count} ;;
  }

  measure: total_first_purchase_revenue {
    type: sum
    sql: ${total_amount_of_order_usd} ;;
    value_format_name: decimal_2

    filters: {
      field: is_first_purchase
      value: "yes"
    }
  }

  measure: first_purchase_count {
    type: count
    drill_fields: [detail*]

    filters: {
      field: is_first_purchase
      value: "yes"
    }
  }

  measure: total_returning_shopper_revenue {
    type: sum
    sql: ${total_amount_of_order_usd} ;;
    value_format_name: decimal_2

    filters: {
      field: is_first_purchase
      value: "no"
    }
  }

  measure: total_order_profit {
    group_label: "Profit Stuff"
    type: sum
    sql: ${order_profit} ;;
    value_format_name: usd
  }

  measure: average_order_profit {
    group_label: "Profit Stuff"
    type: average
    sql: ${order_profit} ;;
    value_format: "$#.00"
  }

  # SETS #
  # Allow to define a set of dimensions, measure combinations. This is useful for setting a drill_path associated with a count
  # or to create sets of dimensions to export when joining views to base views, in case you only want to include some dimensions of a view you join

  set: detail {
    fields: [id, created_time, users.name, users.history, total_cost_of_order]
  }
}

# Counters for views that join 'orders'
#       - order_items.count
#       - products.list
#
#   - dimension: week_starting_tuesday
#     sql: |
#       DATE_ADD(DATE(CONVERT_TZ(orders.created_at,'UTC','America/Los_Angeles')),INTERVAL (0-(DAYOFWEEK(CONVERT_TZ(orders.created_at,'UTC','America/Los_Angeles'))+4)%7) DAY)
#