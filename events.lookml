- view: events
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: id
    type: int

  - dimension: type_id
    type: int

  - dimension: user_id
    type: int
    sets:
      - ignore

  - dimension: value


  # ----- Detail ------
  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id

