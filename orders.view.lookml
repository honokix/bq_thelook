- view: orders
  fields:

# DIMENSIONS #

  - dimension: id
    primary_key: true
    type: int
    sql: ${TABLE}.id

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month, month_num, year, dow_num, hod]
    sql: ${TABLE}.created_at
  
  - dimension: week_starting_tuesday
    sql: |
      DATE_ADD(DATE(CONVERT_TZ(orders.created_at,'UTC','America/Los_Angeles')),INTERVAL (0-(DAYOFWEEK(CONVERT_TZ(orders.created_at,'UTC','America/Los_Angeles'))+4)%7) DAY)
    
  - dimension: status

  - dimension: total_amount_of_order_usd
    type: number
    decimals: 2
    sql: |
      (SELECT SUM(order_items.sale_price) 
      FROM order_items 
      WHERE order_items.order_id = orders.id)

  - dimension: total_amount_of_order_usd_tier
    type: tier
    sql: ${total_amount_of_order_usd}
    tiers: [0,10,50,150,500,1000]

  - dimension: order_items_list
    sql: |
        (SELECT GROUP_CONCAT(products.item_name) 
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        LEFT JOIN products ON inventory_items.product_id = products.id
        WHERE order_items.order_id = orders.id)

  - dimension: total_cost_of_order
    type: number
    decimals: 2
    sql: |
        (SELECT SUM(inventory_items.cost)
        FROM order_items
        LEFT JOIN inventory_items ON order_items.inventory_item_id = inventory_items.id
        WHERE order_items.order_id = orders.id)

  - dimension: total_number_of_items
    type: int
    sql: |
        (SELECT COUNT(order_items.id) 
        FROM order_items 
        WHERE order_items.order_id = orders.id)

  - dimension: order_profit
    type: number
    decimals: 2
    sql: ${total_amount_of_order_usd} - ${total_cost_of_order}
    html: |
      $<%= rendered_value %> 
      
  - measure: profit_per_user
    type: number 
    decimals: 2
    sql: 100.0 * ${order_profit}/NULLIF(${users.count},0)
    html: |
      $<%= rendered_value %>
 
  - dimension: order_sequence_number
    type: number
    sql: |
      (SELECT COUNT(*) 
      FROM orders o
      WHERE o.id < ${TABLE}.id
      AND o.user_id=${TABLE}.user_id) + 1
        
  - dimension: is_first_purchase
    type: yesno
    sql: ${order_sequence_number} = 1

  - dimension: user_id
    type: int
    hidden: true

  - dimension: month_text
    sql_case:
      September: ${created_month_num} = 9
      October: ${created_month_num} = 10
      November: ${created_month_num} = 11
      December: ${created_month_num} = 12
      else: 'Another Month'
    
# MEASURES #

  - measure: average_total_amount_of_order_usd
    type: average
    sql: ${total_amount_of_order_usd}
    decimals: 2
    
  - measure: this_week_count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail
    filters:
      created_date: 7 days
   
  - measure: this_last_14_days_count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail
    filters:
      created_date: 14 days
   
  - measure: this_last_30_days_count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail
    filters:
      created_date: 30 days

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail*
    
  - measure: order_percent_change
    type: percent_of_previous
    sql: ${count}
    
  - measure: count_percent_of_total
    label: Count (Percent of Total)
    type: percent_of_total
    detail: detail*
    decimals: 1
    sql: ${count}
 
  - measure: total_first_purchase_revenue
    type: sum
    sql: ${total_amount_of_order_usd}
    decimals: 2
    filters:
      is_first_purchase: yes
    
  - measure: first_purchase_count
    type: count
    detail: detail*
    filters:
      is_first_purchase: yes
      
  - measure: total_returning_shopper_revenue
    type: sum
    sql: ${total_amount_of_order_usd}
    decimals: 2  
    filters:
      is_first_purchase: no
 
  - measure: total_order_profit
    type: sum
    sql: ${order_profit}
    decimals: 2
    html: |
      $<%= rendered_value %>

  - measure: average_order_profit
    type: average
    sql: ${order_profit}
    decimals: 2
    html: |
      $<%= rendered_value %>

# SETS #

  sets:
    detail:
      - id
      - created_time
      - users.name
      - users.history
      - total_cost_of_order
        # Counters for views that join 'orders'
      - order_items.count
      - products.list
