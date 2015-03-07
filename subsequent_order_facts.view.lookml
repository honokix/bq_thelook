- explore: subsequent_order_facts

- view: subsequent_order_facts
  derived_table:
    sql: |
      select
      orders.id
      ,orders.created_at
      ,orders.user_id
      ,min(later_orders.created_at) AS next_order
      
      
      from orders 
      
      join orders later_orders
      on orders.user_id = later_orders.user_id
      
      
      where
      later_orders.created_at > orders.created_at
      
      group by 1,2,3
      
      

  fields:
  - measure: count
    type: count
    drill_fields: detail*

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: created_at
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: user_id
    type: number
    sql: ${TABLE}.user_id

  - dimension_group: next_order
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.next_order




  sets:
    detail:
      - id
      - created_at
      - user_id
      - minlater_orderscreated_at

