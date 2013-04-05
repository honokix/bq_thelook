- view: events
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: id
    type: int

  - name: created
    type: time
    timeframes: [time, date, week, month]
    sql: $$.created_at

  - name: user_id
    type: int
    sets:
      - ignore

  - name: type_id
    type: int

  - name: value

  # ----- Joins ------

  - join: users
    sql_on: events.user_id=users.id
    base_only: true

  # ----- Detail ------
  sets:
    detail: [
        id,
        users.last_name,
        users.first_name,
        users.id,
    ]

