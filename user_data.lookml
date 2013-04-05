- view: user_data
  fields:

  - name: count
    type: count_distinct
    sql: $$.id
    detail: detail

  - name: has_ordered
    type: yesno

  - name: one_order
    type: yesno

  - name: user_id
    type: int
    sets:
      - ignore

  - name: id
    type: int

  # ----- Joins ------

  - join: users
    sql_on: user_data.user_id=users.id
    base_only: true

  # ----- Detail ------
  sets:
    detail: [
        id,
        users.last_name,
        users.first_name,
        users.id,
    ]

