- view: events
  fields:

  - measure: count
    type: count
    detail: detail

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: id
    type: int
    primary_key: true

  - dimension: type_id
    type: int

  - dimension: user_id
    type: int
    hidden: true

  - dimension: value


  # ----- Detail ------
  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id

