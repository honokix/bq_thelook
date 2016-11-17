- view: events
  fields:

  - dimension: id
    primary_key: true
    type: number
    sql: ${TABLE}.id

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: type_id
    type: number
    sql: ${TABLE}.type_id

  - dimension: user_id
    type: number
    hidden: true
    sql: ${TABLE}.user_id

  - dimension: value
    sql: ${TABLE}.value

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
