- view: users
  fields:

  - measure: count
    type: count_distinct
    sql: ${TABLE}.id
    detail: detail

  - dimension: age
    type: int

  - dimension: city

  - dimension: country

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: email

  - dimension: first_name

  - dimension: gender

  - dimension: id
    type: int

  - dimension: last_name

  - dimension: state

  - dimension: zip
    type: int


  # ----- Detail ------
  sets:
    detail:
      - last_name
      - first_name
      - id
        # Counters for views that join 'users'
      - events.count
      - orders.count
      - user_data.count

