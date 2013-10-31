- view: events
  fields:

# DIMENSIONS #

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

# MEASURES #

  - measure: count
    type: count
    detail: detail
  
# SETS #

  sets:
    detail:
      - id
      - users.last_name
      - users.first_name
      - users.id