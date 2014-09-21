- view: user_data
  fields:

  - dimension: id
    primary_key: true
    type: int
    sql: ${TABLE}.id

  - dimension: max_num_orders
    type: int
    sql: ${TABLE}.max_num_orders

  - dimension: total_num_orders
    type: int
    sql: ${TABLE}.total_num_orders

  - dimension: user_id
    type: int
    hidden: true
    sql: ${TABLE}.user_id

  - measure: count
    type: count
    drill_fields: detail*


  # ----- Detail ------
  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id